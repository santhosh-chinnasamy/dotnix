{ pkgs, ... }:
let
  hypr-window-pop = pkgs.writeShellApplication {
    name = "hypr-window-pop";
    runtimeInputs = [ pkgs.hyprland ];
    text = ''
      # Float + pin so the window follows across workspaces (Omarchy pop).
      # Hyprland 0.57 Lua configs need Lua dispatchers, not legacy names.
      hyprctl dispatch "hl.dsp.window.float({ action = 'enable' })"
      hyprctl dispatch "hl.dsp.window.pin({ action = 'enable' })"
    '';
  };

  hypr-screenrecord-toggle = pkgs.writeShellApplication {
    name = "hypr-screenrecord-toggle";
    runtimeInputs = [
      pkgs.wl-screenrec
      pkgs.slurp
      pkgs.libnotify
      pkgs.coreutils
    ];
    text = ''
      pidfile="''${XDG_RUNTIME_DIR:-/tmp}/wl-screenrec.pid"
      outdir="''${OMARCHY_SCREENRECORD_DIR:-$HOME/Videos}"
      mkdir -p "$outdir"

      if [[ -f "$pidfile" ]] && kill -0 "$(cat "$pidfile")" 2>/dev/null; then
        kill -INT "$(cat "$pidfile")" || true
        rm -f "$pidfile"
        notify-send -a Recording "Screen recording stopped"
        exit 0
      fi

      geom="$(slurp)" || exit 0
      outfile="$outdir/screenrecording-$(date +%Y-%m-%d_%H-%M-%S).mp4"
      wl-screenrec -g "$geom" -f "$outfile" &
      echo $! >"$pidfile"
      notify-send -a Recording "Screen recording started" "$outfile"
    '';
  };

  hypr-screenshot-full = pkgs.writeShellApplication {
    name = "hypr-screenshot-full";
    runtimeInputs = [
      pkgs.grim
      pkgs.satty
      pkgs.jq
      pkgs.hyprland
      pkgs.coreutils
      pkgs.wl-clipboard
    ];
    text = ''
      outdir="''${XDG_PICTURES_DIR:-$HOME/Pictures}/Screenshots"
      mkdir -p "$outdir"
      outfile="$outdir/screenshot-$(date +%Y-%m-%d_%H-%M-%S).png"
      # Focused monitor geometry via hyprctl (shell-agnostic; no DMS/Noctalia).
      mon="$(hyprctl monitors -j | jq -r '.[] | select(.focused) | "\(.x),\(.y) \(.width)x\(.height)"')"
      grim -g "$mon" -t ppm - | satty --filename - --fullscreen --output-filename "$outfile" --copy-command wl-copy
    '';
  };

  hypr-screenshot-region = pkgs.writeShellApplication {
    name = "hypr-screenshot-region";
    runtimeInputs = [
      pkgs.grim
      pkgs.slurp
      pkgs.satty
      pkgs.coreutils
      pkgs.wl-clipboard
    ];
    text = ''
      outdir="''${XDG_PICTURES_DIR:-$HOME/Pictures}/Screenshots"
      mkdir -p "$outdir"
      outfile="$outdir/screenshot-$(date +%Y-%m-%d_%H-%M-%S).png"
      geom="$(slurp -d)" || exit 0
      grim -g "$geom" -t ppm - | satty --filename - --output-filename "$outfile" --copy-command wl-copy
    '';
  };

  walker-ensure = pkgs.writeShellApplication {
    name = "walker-ensure";
    runtimeInputs = [
      pkgs.procps
      pkgs.coreutils
    ];
    text = ''
      # Keep Walker's GApplication service alive for instant Super+Space launcher.
      if pgrep -x walker >/dev/null; then
        exit 0
      fi
      # walker may live under a wrapped path; prefer PATH resolution.
      if command -v walker >/dev/null; then
        nohup walker --gapplication-service >/dev/null 2>&1 &
        disown || true
      fi
    '';
  };

  hypr-ocr = pkgs.writeShellApplication {
    name = "hypr-ocr";
    runtimeInputs = [
      pkgs.grim
      pkgs.slurp
      pkgs.tesseract
      pkgs.wl-clipboard
      pkgs.libnotify
    ];
    text = ''
      geom="$(slurp)" || exit 0
      text="$(grim -g "$geom" - | tesseract stdin stdout 2>/dev/null | sed 's/[[:space:]]*$//')"
      if [[ -z "''${text//[[:space:]]/}" ]]; then
        notify-send -a OCR "No text found"
        exit 1
      fi
      printf '%s' "$text" | wl-copy
      notify-send -a OCR "Copied to clipboard" "$text"
    '';
  };

  hypr-keybinds-help = pkgs.writeShellApplication {
    name = "hypr-keybinds-help";
    runtimeInputs = [
      pkgs.ghostty
      pkgs.bat
    ];
    text = ''
      file="''${XDG_CONFIG_HOME:-$HOME/.config}/hypr/KEYBINDS.md"
      if [[ ! -f "$file" ]]; then
        file="$HOME/.config/hypr/KEYBINDS.md"
      fi
      exec ghostty --class=floating-tui -e bat --paging=always --style=plain "$file"
    '';
  };

  floating-tui = pkgs.writeShellApplication {
    name = "floating-tui";
    runtimeInputs = [ pkgs.ghostty ];
    text = ''
      if [[ $# -lt 1 ]]; then
        echo "usage: floating-tui <command> [args...]" >&2
        exit 1
      fi
      export LANG="''${LANG:-C.UTF-8}"
      export LC_ALL="''${LC_ALL:-C.UTF-8}"
      export LC_CTYPE="''${LC_CTYPE:-C.UTF-8}"
      exec ghostty --class=floating-tui -e "$@"
    '';
  };

  nightlight-toggle = pkgs.writeShellApplication {
    name = "nightlight-toggle";
    runtimeInputs = [ pkgs.libnotify ];
    text = ''
      if systemctl --user is-active --quiet gammastep.service; then
        systemctl --user stop gammastep.service
        notify-send -a Nightlight "Nightlight off"
      else
        systemctl --user start gammastep.service
        notify-send -a Nightlight "Nightlight on"
      fi
    '';
  };

  # Regenerate a feature-grouped copy of the running Hyprland keybinds and open
  # it in DMS's keybind overlay. DMS auto-discovers ~/.config/dms/cheatsheets/*.json.
  hypr-keybinds-overlay = pkgs.writeShellApplication {
    name = "hypr-keybinds-overlay";
    runtimeInputs = [
      pkgs.jq
      pkgs.coreutils
      pkgs.hyprland
      pkgs.libnotify
    ];
    text = ''
      dir="''${XDG_CONFIG_HOME:-$HOME/.config}/dms/cheatsheets"
      mkdir -p "$dir"
      active="$(mktemp)"
      parsed="$(mktemp)"
      # Same filesystem as the target so the final mv is an atomic rename, and
      # the non-.json name keeps DMS from discovering a half-written file.
      out="$(mktemp "$dir/.hyprland-grouped.XXXXXX")"
      trap 'rm -f "$active" "$parsed" "$out"' EXIT

      # hyprctl prints its error on stdout, so a plain fallback would break jq.
      if ! hyprctl binds -j > "$active" 2>/dev/null; then
        notify-send -a "Keybind cheatsheet" "Hyprland is not reachable" || true
        exit 1
      fi

      dms keybinds show hyprland > "$parsed" 2>/dev/null || echo '{"binds":{}}' > "$parsed"

      if ! jq -n --slurpfile active "$active" --slurpfile parsed "$parsed" \
        -f ${./hypr-cheatsheet.jq} > "$out" || [[ ! -s "$out" ]]; then
        notify-send -a "Keybind cheatsheet" "Failed to build keybind list" || true
        exit 1
      fi
      mv "$out" "$dir/hyprland-grouped.json"

      dms ipc call keybinds toggle hyprland-grouped
    '';
  };
in
{
  home.packages = [
    hypr-window-pop
    hypr-screenrecord-toggle
    hypr-screenshot-full
    hypr-screenshot-region
    walker-ensure
    hypr-ocr
    hypr-keybinds-help
    hypr-keybinds-overlay
    floating-tui
    nightlight-toggle
    pkgs.hyprpicker
    pkgs.wl-screenrec
    pkgs.slurp
    pkgs.grim
    pkgs.satty
    pkgs.kooha
    pkgs.tesseract
    pkgs.wtype
    pkgs.jq
    pkgs.wl-clipboard
  ];

  services.gammastep = {
    enable = true;
    # Manual coords avoid requiring system geoclue; adjust if you travel.
    provider = "manual";
    latitude = 12.97;
    longitude = 77.59;
    temperature = {
      day = 6500;
      night = 3800;
    };
    tray = true;
  };
}
