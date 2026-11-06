{
  config,
  lib,
  pkgs,
  ...
}:
let
  toolsMenu = pkgs.writeText "walker-tools-menu.toml" ''
    name = "tools"
    name_pretty = "Tools"
    icon = "utilities-terminal"
    action = "%VALUE%"

    [[entries]]
    text = "Activity (btop)"
    value = "floating-tui btop --force-utf"
    icon = "utilities-system-monitor"

    [[entries]]
    text = "Lazygit"
    value = "floating-tui lazygit"
    icon = "git"

    [[entries]]
    text = "Emoji / symbols"
    value = "walker -s symbols"
    icon = "face-smile"

    [[entries]]
    text = "Screen record (Kooha)"
    value = "kooha"
    icon = "camera-video"

    [[entries]]
    text = "Voxtype configure"
    value = "floating-tui voxtype configure"
    icon = "audio-input-microphone"

    [[entries]]
    text = "Voxtype status"
    value = "floating-tui sh -c 'voxtype status; echo; read -n1 -s -r -p \"Press any key...\"'"
    icon = "audio-input-microphone"

    [[entries]]
    text = "Keybinds help"
    value = "hypr-keybinds-help"
    icon = "input-keyboard"

    [[entries]]
    text = "Nightlight toggle"
    value = "nightlight-toggle"
    icon = "weather-clear-night"
  '';

  websearchConfig = pkgs.writeText "elephant-websearch.toml" ''
    [[entries]]
    default = true
    name = "Google"
    url = "https://www.google.com/search?q=%TERM%"

    [[entries]]
    name = "DuckDuckGo"
    url = "https://duckduckgo.com/?q=%TERM%"

    [[entries]]
    name = "GitHub"
    url = "https://github.com/search?q=%TERM%"

    command = "xdg-open"
  '';

  # Focus already-open apps instead of spawning broken/duplicate instances.
  desktopAppsConfig = pkgs.writeText "elephant-desktopapplications.toml" ''
    window_integration = true
    ignore_pin_with_window = true
    score_open_windows = true
    history = true
  '';
in
{
  # Walker + Elephant replace the DMS/Noctalia app launcher (Super+Space).
  services.elephant.enable = true;

  services.walker = {
    enable = true;
    enableElephantIntegration = true;
    # Start from Hyprland after WAYLAND_DISPLAY is imported (systemd raced and failed).
    systemd.enable = false;
    settings = {
      close_when_open = true;
      force_keyboard_focus = true;
      theme = "default";
      placeholders.default = {
        input = "Search";
        list = "No results";
      };
      providers = {
        default = [
          "desktopapplications"
          "calc"
          "runner"
          "menus"
          "websearch"
          "files"
          "clipboard"
          "windows"
          "symbols"
        ];
        empty = [ "desktopapplications" ];
        # Provider sets
        sets.tools = {
          default = [ "menus:tools" ];
          empty = [ "menus:tools" ];
        };
        # Optional windows provider set (Super+Tab is Snappy; keep for tools / manual use)
        sets.switcher = {
          default = [ "windows" ];
          empty = [ "windows" ];
        };
        # Super+. emoji / symbols picker
        sets.symbols = {
          default = [ "symbols" ];
          empty = [ "symbols" ];
        };
        prefixes = [
          {
            provider = "files";
            prefix = "/";
          }
          {
            provider = "calc";
            prefix = "=";
          }
          {
            provider = "clipboard";
            prefix = ":";
          }
          {
            provider = "symbols";
            prefix = ".";
          }
          # Official Walker websearch prefix is @
          {
            provider = "websearch";
            prefix = "@";
          }
          {
            provider = "providerlist";
            prefix = ";";
          }
          {
            provider = "runner";
            prefix = ">";
          }
          {
            provider = "menus:tools";
            prefix = "!";
          }
        ];
        actions.websearch = [
          {
            action = "search";
            default = true;
            bind = "Return";
          }
        ];
      };
    };
  };

  xdg.configFile = {
    "elephant/menus/tools.toml".source = toolsMenu;
    "elephant/websearch.toml".source = websearchConfig;
    "elephant/desktopapplications.toml".source = desktopAppsConfig;
    # Drop-in merges with the vendor unit. A full HM service override would
    # replace ExecStart and break activation (BadUnitSetting / NOPERMISSION).
    "systemd/user/xdg-desktop-portal-hyprland.service.d/wayland.conf".text = ''
      [Unit]
      After=hyprland-session.target
      ConditionEnvironment=WAYLAND_DISPLAY
    '';
  };

  systemd.user.services.elephant = {
    Unit = {
      After = lib.mkForce [ "hyprland-session.target" ];
      PartOf = lib.mkForce [ "hyprland-session.target" ];
      ConditionEnvironment = "WAYLAND_DISPLAY";
    };
    Install.WantedBy = lib.mkForce [ "hyprland-session.target" ];
  };

  # Long-running Walker GApplication service (instant Super+Space launcher).
  # Started after hyprland-session so WAYLAND_DISPLAY is present.
  systemd.user.services.walker-ensure = {
    Unit = {
      Description = "Walker GApplication service";
      After = [ "hyprland-session.target" ];
      PartOf = [ "hyprland-session.target" ];
      ConditionEnvironment = "WAYLAND_DISPLAY";
    };
    Service = {
      Type = "simple";
      ExecStart = "${config.home.profileDirectory}/bin/walker --gapplication-service";
      Restart = "on-failure";
      RestartSec = 2;
    };
    Install.WantedBy = [ "hyprland-session.target" ];
  };
}
