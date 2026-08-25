{ inputs, lib, pkgs, ... }:

{
  imports = [
    inputs.noctalia.homeModules.default
  ];

  programs.noctalia = {
    enable = true;
    settings = {
      shell = {
        font_family = "JetBrainsMono Nerd Font Mono";
        polkit_agent = true;
        launch_apps_as_systemd_services = true;
        launcher = {
          app_grid = true;
          show_app_actions = true;
        };
      };

      theme = {
        mode = "dark";
        source = "community";
        community_palette = "Monochrome";
        pure_black_dark = true;
      };

      bar = {
        default = {
          position = "top";
          capsule_thickness = 0.69;
          margin_ends = 0;
          start = [
            "launcher"
            "workspaces"
            "active_window"
          ];
          center = [
            # "media"
            "clock"
          ];
          end = [
            "tray"
            "clipboard"
            "sysmon"
            "network"
            "bluetooth"
            "volume"
            "brightness"
            "power_profile"
            "battery"
            "control-center"
            "notifications"
            "session"
          ];
        };
      };

      widget = {
        clock = {
          format = "{:%I:%M %p %a, %b %d}";
        };

        sysmon = {
          stat = "cpu_usage";
        };
      };

      dock = {
        enabled = false;
        position = "bottom";
      };

      # Keep desktop widgets off until the v5 layout is rebuilt explicitly.
      desktop_widgets.enabled = true;
    };

    systemd.enable = true;
  };

  systemd.user.targets.hyprland-session = {
    Unit = {
      Description = "Hyprland session target";
      BindsTo = [ "graphical-session.target" ];
      Wants = [ "graphical-session-pre.target" ];
      After = [ "graphical-session-pre.target" ];
    };
  };

  systemd.user.services.noctalia = {
    Unit = {
      PartOf = [ "hyprland-session.target" ];
      After = [ "hyprland-session.target" ];
      ConditionEnvironment = "WAYLAND_DISPLAY";
    };
    Service = {
      RestartSec = 1;
    };
    Install.WantedBy = lib.mkAfter [ "hyprland-session.target" ];
  };
}
