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
            "workspaces"
            "launcher"
            "active_window"
          ];
          center = [
            "media"
            "clock"
          ];
          end = [
            "tray"
            "sysmon"
            "notifications"
            "network"
            "bluetooth"
            "volume"
            "brightness"
            "power_profile"
            "battery"
            "control-center"
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
        enabled = true;
        position = "bottom";
      };

      # Keep desktop widgets off until the v5 layout is rebuilt explicitly.
      desktop_widgets.enabled = false;
    };

    systemd.enable = true;
  };

  systemd.user.targets.hyprland-session = {
    Unit = {
      Description = "Hyprland session target";
      Requires = [ "graphical-session.target" ];
      After = [ "graphical-session.target" ];
    };
  };

  systemd.user.services.noctalia = {
    Unit = {
      PartOf = [ "hyprland-session.target" ];
      After = [ "hyprland-session.target" ];
    };
    Install.WantedBy = lib.mkAfter [ "hyprland-session.target" ];
  };
}
