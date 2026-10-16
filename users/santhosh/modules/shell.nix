{ config, lib, ... }:
let
  cfg = config.custom.desktop;
in
{
  options.custom.desktop.shell = lib.mkOption {
    type = lib.types.enum [
      "dms"
      "noctalia"
      "none"
    ];
    default = "dms";
    description = "The active Wayland desktop shell suite.";
  };

  config = {
    systemd.user.targets.hyprland-session = lib.mkIf (cfg.shell != "none") {
      Unit = {
        Description = "Hyprland session target";
        BindsTo = [ "graphical-session.target" ];
        Wants = [ "graphical-session-pre.target" ];
        After = [ "graphical-session-pre.target" ];
      };
    };

    xdg.configFile."hypr/config/constants.lua".text = ''
      return {
        main_mod = "SUPER",
        shell = "${cfg.shell}",
        ipc = "${
          if cfg.shell == "dms" then
            "dms ipc call "
          else if cfg.shell == "noctalia" then
            "noctalia msg "
          else
            ""
        }",
      }
    '';
  };
}
