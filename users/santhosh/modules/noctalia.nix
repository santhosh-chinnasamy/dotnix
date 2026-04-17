{ inputs, pkgs, ... }:

{
  imports = [
    inputs.noctalia.homeModules.default
  ];

  programs.noctalia-shell = {
    enable = true;

    # optional basic bar config
    settings = {
      bar = {
        barType = "simple";
        position = "top";
        density = "comfortable";
        showCapsule = true;
        widgets = {
          left = [
            {
              id = "Workspace";
            }
            {
              id = "Launcher";
            }
            {
              id = "ActiveWindow";
            }
          ];
          center = [
            { id = "MediaMini"; }
            {
              id = "Clock";
              formatHorizontal = "hh:mm AP ddd, MMM dd";
            }
          ];
          right = [
            { id = "Tray"; }
            { id = "SystemMonitor"; }
            { id = "NotificationHistory"; }
            { id = "Network"; }
            {
              id = "Battery";
              showNoctaliaPerformance = true;
              showPowerProfiles = true;
              displayMode = "icon-always";
            }
            { id = "Volume"; }
            { id = "Brightness"; }
            { id = "ControlCenter"; }
          ];
        };
      };
      ui = {
        fontDefault = "JetBrainsMono Nerd Font";
        fontFixed = "monospace";
        fontDefaultScale = 1;
        fontFixedScale = 1;
        tooltipsEnabled = true;
        scrollbarAlwaysVisible = true;
        boxBorderEnabled = false;
        panelBackgroundOpacity = 0.93;
        translucentWidgets = false;
        panelsAttachedToBar = true;
        settingsPanelMode = "attached";
        settingsPanelSideBarCardStyle = false;
      };
      dock = {
        enabled = true;
        position = "bottom";
        #displayMode = "auto_hide";
      };
    };

    # enable systemd service (recommended)
    systemd.enable = true;
  };
}
