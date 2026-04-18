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
            { id = "Bluetooth"; }
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
      general = {
        telemetryEnabled = false;
        autoStartAuth = true;
        allowPasswordWithFprintd = true;
      };
      appLauncher = {
        enableClipboardHistory = true;
        autoPasteClipboard = false;
        enableClipPreview = true;
        clipboardWrapText = true;
        enableClipboardSmartIcons = true;
        enableClipboardChips = true;
        clipboardWatchTextCommand = "wl-paste --type text --watch cliphist store";
        clipboardWatchImageCommand = "wl-paste --type image --watch cliphist store";
        position = "center";
        pinnedApps = [ ];
        sortByMostUsed = true;
        terminalCommand = "ghostty -e";
        customLaunchPrefixEnabled = false;
        customLaunchPrefix = "";
        viewMode = "grid";
        showCategories = true;
        iconMode = "tabler";
        showIconBackground = false;
        enableSettingsSearch = true;
        enableWindowsSearch = true;
        enableSessionSearch = true;
        ignoreMouseInput = false;
        screenshotAnnotationTool = "";
        overviewLayer = true;
        density = "comfortable";
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
      esktopWidgets = {
        enabled = true;
        overviewEnabled = true;
        gridSnap = false;
        gridSnapScale = false;
        monitorWidgets = [
          {
            name = "eDP-1";
            widgets = [
              {
                clockColor = "none";
                clockStyle = "minimal";
                format = "hh=mm AP\\nd MMMM yyyy";
                id = "Clock";
                roundedCorners = true;
                scale = "1.6720092414745276";
                showBackground = true;
                useCustomFont = false;
                x = "1853";
                y = "253";
              }
            ];
          }
        ];
      };
    };

    # enable systemd service (recommended)
    systemd.enable = true;
  };
}
