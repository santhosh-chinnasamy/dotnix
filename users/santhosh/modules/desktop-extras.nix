{ pkgs, ... }:
let
  hypr-window-pop = pkgs.writeShellApplication {
    name = "hypr-window-pop";
    runtimeInputs = [ pkgs.hyprland ];
    text = ''
      # Float + pin so the window follows across workspaces (Omarchy pop).
      hyprctl --batch "dispatch setfloating active; dispatch pin active"
    '';
  };

  hypr-layout-cycle = pkgs.writeShellApplication {
    name = "hypr-layout-cycle";
    runtimeInputs = [
      pkgs.hyprland
      pkgs.jq
      pkgs.libnotify
    ];
    text = ''
      current="$(hyprctl getoption general:layout -j | jq -r '.str')"
      case "$current" in
        scrolling)
          next="dwindle"
          tip="Windows split into a tree (Super+J flips orientation)"
          ;;
        *)
          next="scrolling"
          tip="Windows line up in a horizontal strip you can scroll"
          ;;
      esac

      # Keyword is session-wide; new windows on every workspace follow it until reload.
      hyprctl keyword general:layout "$next"
      actual="$(hyprctl getoption general:layout -j | jq -r '.str')"
      if [[ "$actual" != "$next" ]]; then
        notify-send -a Hyprland "Layout failed" "wanted $next, got $actual"
        exit 1
      fi
      notify-send -a Hyprland "Layout: $actual" "$tip"
    '';
  };

  hypr-screenrecord-toggle = pkgs.writeShellApplication {
    name = "hypr-screenrecord-toggle";
    runtimeInputs = [
      pkgs.wf-recorder
      pkgs.slurp
      pkgs.libnotify
      pkgs.coreutils
    ];
    text = ''
      pidfile="''${XDG_RUNTIME_DIR:-/tmp}/wf-recorder.pid"
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
      wf-recorder -g "$geom" -f "$outfile" &
      echo $! >"$pidfile"
      notify-send -a Recording "Screen recording started" "$outfile"
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
in
{
  home.packages = [
    hypr-window-pop
    hypr-layout-cycle
    hypr-screenrecord-toggle
    hypr-ocr
    hypr-keybinds-help
    floating-tui
    nightlight-toggle
    pkgs.hyprpicker
    pkgs.wf-recorder
    pkgs.slurp
    pkgs.grim
    pkgs.tesseract
    pkgs.wtype
    pkgs.jq
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
