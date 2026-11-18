# Hyprland keybinds (Omarchy-inspired)

Super is the Windows / Command key.

## Tab / app switching

| Keys | Action |
| --- | --- |
| Super + Tab (hold Super) | **App switcher** — Snappy Switcher; release Super to focus |
| Super + Shift + Tab | Previous window in the Snappy list |
| Super + ` (in switcher) | Next in list / same-app when switcher closed |
| Super + Shift + ` | Cycle same app reverse (when switcher closed) |
| Alt + Tab | Next window in group (tabbed stack in one tile) |
| Alt + Shift + Tab | Previous in group |
| Super + Ctrl + Tab | DMS workspace overview / Noctalia window switcher |

## Shortcuts overlay

| Shell | Super + K | Super + Shift + K |
| --- | --- | --- |
| DMS | Native DMS keybind overlay | Floating `KEYBINDS.md` |
| Noctalia / none | Floating `KEYBINDS.md` | — |

Walker (`Super + Space`, tools `!`) remains the launcher — not the app switcher.

## Screenshots & recording (Mac-like)

Shell-agnostic stack: **Satty** (annotate), **Kooha** (GUI capture/record), **wl-screenrec** (hotkey region).

| Keys | Action |
| --- | --- |
| Super + Shift + 3 | Fullscreen → Satty (annotate / save / copy) |
| Super + Shift + 4 | Region → Satty |
| Super + Shift + 5 | Kooha (capture & screen-record UI) |
| Print / Shift + Print | Quick shell screenshot (DMS or grimblast) |
| Alt + Print | Toggle region recording (wl-screenrec) |
| Super + Ctrl + Print | OCR region → clipboard |
| Super + Print | Color picker |

Saved screenshots: `~/Pictures/Screenshots/`. Recordings: `~/Videos/`.

## Word jump & emoji

| Keys | Action |
| --- | --- |
| Alt + Left / Right | Word jump (Mac Option; sends Ctrl+arrows) |
| Super + . | Emoji / symbols (Walker) |
| `.` in Walker | Symbols prefix |

## Workspaces

| Keys | Action |
| --- | --- |
| Super + [1–9] | Focus workspace N |
| Super + Ctrl + [1–9] | Move window to workspace N (follow) |
| Super + Shift + Alt + [1–9] | Silent move to workspace N |
| Super + 0 | Previous workspace |
| Super + Ctrl + 0 | Move to previous workspace |

Super+Shift+[3/4/5] are screenshots, so move uses Super+Ctrl instead of Super+Shift.

## Layout

`Super + Shift + L` toggles **this workspace** between dwindle and scrolling via `workspace_rule` (Hyprland 0.57 ignores `hyprctl keyword general:layout`).

`Super + J` only works on dwindle (flips split orientation).

## Launch

| Keys | Action |
| --- | --- |
| Super + Space | Walker launcher |
| Super + Shift + Space / `!` | Tools menu |
| `@query` | Web search |
| Super + Return | Terminal |
| Super + Shift + T | btop (`--force-utf`) |
| Super + K | Keybind cheatsheet |

## Voxtype

Focus a text field → `Super + Ctrl + X` toggle (or hold F9) → speak → toggle/release. Configure: `Super + Ctrl + Alt + X`.

## Auth popups (polkit)

Privileged apps (`pkexec`, some Flatpaks, system settings) show a **hyprpolkitagent** dialog (fingerprint via fprintd, or password).

DMS/Noctalia built-in polkit agents are disabled (`DMS_DISABLE_POLKIT=1`, noctalia `polkit_agent = false`) so only hyprpolkitagent registers. Check: `systemctl --user status hyprpolkitagent`.

## VS Code encryption

Chromium/Electron keyring pins live in `users/santhosh/modules/electron-keyring.nix` (`*-flags.conf` + VS Code–fork `argv.json`). Unlock the login keyring at session start (Seahorse) if a “weaker encryption” banner persists.
