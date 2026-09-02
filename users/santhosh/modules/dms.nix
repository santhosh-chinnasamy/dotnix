{ config, inputs, lib, ... }:
let
  enableDms = config.custom.desktop.shell == "dms";
in
{
  imports = [
    inputs.dms.homeModules.dank-material-shell
  ];

  config = lib.mkIf enableDms {
    programs.dank-material-shell = {
      enable = true;
      systemd = {
        enable = true;
        restartIfChanged = true;
        target = "hyprland-session.target";
      };
      enableSystemMonitoring = true;
      enableVPN = true;
      enableDynamicTheming = true;
      enableAudioWavelength = true;
      enableCalendarEvents = true;
    };
  };
}
