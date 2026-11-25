# Build a feature-grouped DMS cheatsheet from the *running* Hyprland binds.
#
# `hyprctl binds -j` is the source of truth for which binds are active (and
# gives accurate descriptions), while `dms keybinds show hyprland` supplies the
# action/luaAction used by the overlay's click-to-run. Matching them also drops
# the hl.bind calls that live in inactive `shell == "…"` branches, which the
# static parser cannot evaluate.
#
# Usage:
#   jq -n --slurpfile active <(hyprctl binds -j) \
#         --slurpfile parsed <(dms keybinds show hyprland) \
#         -f hypr-cheatsheet.jq

def mods($m):
  [
    (if (($m / 64 | floor) % 2) == 1 then "SUPER" else empty end),
    (if (($m / 4 | floor) % 2) == 1 then "CTRL" else empty end),
    (if (($m / 8 | floor) % 2) == 1 then "ALT" else empty end),
    (if ($m % 2) == 1 then "SHIFT" else empty end)
  ];

# Canonical key: modifier order does not matter, leaf key does.
def canon:
  (ascii_upcase | split("+") | map(gsub("^\\s+|\\s+$"; ""))) as $p
  | if ($p | length) <= 1 then
      ($p[0] // "")
    else
      ((($p[0:-1] | sort) + [$p[-1]]) | join("+"))
    end;

def category:
  if test("screenshot|ocr|record|capture|color picker") then "Capture"
  elif test("dictation|voxtype") then "Dictation"
  elif test("workspace|scratchpad|overview") then "Workspaces"
  elif test("window|float|pseudo|split|fullscreen|maximiz|\\bgroups?\\b|focus|swap|resize|shrink|grow|\\bpin\\b|\\bpop\\b|cycle same app") then "Windows"
  elif test("audio|volume|brightness|mute|nightlight|play|pause|track|next|previous") then "Media"
  elif test("copy|paste|cut|word jump") then "Editing"
  elif test("lock|power|reload|settings|notification|clipboard|keybind|cheatsheet|spotlight") then "System"
  else "Applications"
  end;

(($parsed[0].binds // {}) | [to_entries[] | .value[]]) as $p
| (($active[0] // [])) as $a
| [
    $a[] as $b
    | (mods($b.modmask) + [$b.key] | join("+")) as $hkey
    | ($hkey | canon) as $ck
    | ([ $p[] | select((.key | canon) == $ck) ]) as $candidates
    | (($candidates | map(select((.desc // "") == ($b.description // ""))) | .[0])
       // $candidates[0]
       // {}) as $m
    | (if ($b.description // "") != "" then $b.description else ($m.desc // "") end) as $desc
    | {
        key: ($m.key // $hkey),
        desc: $desc,
        action: ($m.action // ""),
        luaAction: ($m.luaAction // ""),
        flags: ($m.flags // ""),
        source: ($m.source // ""),
        group: ($desc | ascii_downcase | category)
      }
  ]
# Let DMS recognize its own toggle chord so Super+K closes the overlay even
# while the search field has focus (KeybindsContent.ownToggleCombos()).
# luaAction stays empty so the row is never click-dispatched.
| map(
    if ((.action // "") | test("hypr-keybinds-overlay")) then
      .action = "dms ipc call keybinds toggle hyprland-grouped"
      | .luaAction = ""
    else
      .
    end
  )
| unique_by([.key, .desc])
| sort_by(.group)
| group_by(.group)
| {
    title: "Hyprland Keybinds",
    provider: "hyprland-grouped",
    mod: ($parsed[0].mod // {"symbol": "", "resolved": "Super", "source": "default"}),
    modKey: "Super",
    binds: (map({key: .[0].group, value: map(del(.group))}) | from_entries)
  }
