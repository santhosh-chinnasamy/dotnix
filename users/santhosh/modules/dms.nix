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

      settings = {
        currentThemeName = "dynamic";
        currentThemeCategory = "dynamic";
        matugenScheme = "scheme-monochrome";
        cornerRadius = 12;
        controlCenterShowMicPercent = true;
        controlCenterWidgets = [
          {
            id = "volumeSlider";
            enabled = true;
            width = 50;
          }
          {
            id = "brightnessSlider";
            enabled = true;
            width = 50;
          }
          {
            id = "wifi";
            enabled = true;
            width = 50;
          }
          {
            id = "bluetooth";
            enabled = true;
            width = 50;
          }
          {
            id = "audioOutput";
            enabled = true;
            width = 50;
          }
          {
            id = "audioInput";
            enabled = true;
            width = 50;
          }
          {
            id = "nightMode";
            enabled = true;
            width = 50;
          }
          {
            id = "darkMode";
            enabled = true;
            width = 50;
          }
          {
            id = "doNotDisturb";
            enabled = true;
            width = 50;
          }
        ];
        showWorkspaceIndex = true;
        showWorkspaceApps = true;
        appIdSubstitutions = [ ];
        centeringMode = "geometric";
        spotlightSectionViewModes = {
          apps = "grid";
        };
        cursorSettings = {
          theme = "System Default";
          size = 24;
          niri = {
            hideWhenTyping = false;
            hideAfterInactiveMs = 0;
          };
          hyprland = {
            hideOnKeyPress = false;
            hideOnTouch = false;
            inactiveTimeout = 0;
          };
          mango = {
            cursorHideTimeout = 0;
          };
        };
        fontFamily = "JetBrainsMono NF";
        monoFontFamily = "JetBrainsMono Nerd Font";
        terminalsAlwaysDark = true;
        osdAlwaysShowValue = true;
        osdPowerProfileEnabled = true;
        screenPreferences = {
          wallpaper = [ "all" ];
        };
        barConfigs = [
          {
            id = "default";
            name = "Main Bar";
            enabled = true;
            position = 0;
            screenPreferences = [ "all" ];
            showOnLastDisplay = true;
            leftWidgets = [
              {
                id = "launcherButton";
                enabled = true;
              }
              {
                id = "workspaceSwitcher";
                enabled = true;
              }
              {
                id = "focusedWindow";
                enabled = true;
                focusedWindowSize = 0;
                focusedWindowCompactMode = true;
              }
            ];
            centerWidgets = [
              {
                id = "music";
                enabled = true;
              }
              {
                id = "clock";
                enabled = true;
                clockCompactMode = false;
                clockDateOrder = "dateFirst";
              }
            ];
            rightWidgets = [
              {
                id = "systemTray";
                enabled = true;
                trayUseInlineExpansion = true;
              }
              {
                id = "clipboard";
                enabled = true;
              }
              {
                id = "notificationButton";
                enabled = true;
              }
              {
                id = "battery";
                enabled = true;
              }
              {
                id = "controlCenterButton";
                enabled = true;
              }
              {
                id = "powerMenuButton";
                enabled = true;
              }
              {
                id = "music";
                enabled = true;
              }
            ];
            spacing = 4;
            innerPadding = 4;
            barInsetPadding = -1;
            barLengthPadding = 0;
            bottomGap = 0;
            attachToScreenEdge = false;
            transparency = 1;
            widgetTransparency = 1;
            squareCorners = true;
            noBackground = false;
            maximizeWidgetIcons = false;
            maximizeWidgetText = false;
            removeWidgetPadding = true;
            widgetPadding = 8;
            gothCornersEnabled = false;
            gothCornerRadiusOverride = false;
            gothCornerRadiusValue = 12;
            borderEnabled = false;
            borderColor = "surfaceText";
            borderOpacity = 1;
            borderThickness = 1;
            widgetOutlineEnabled = false;
            widgetOutlineColor = "primary";
            widgetOutlineOpacity = 1;
            widgetOutlineThickness = 1;
            fontScale = 1;
            iconScale = 1;
            autoHide = false;
            autoHideStrict = false;
            autoHideDelay = 250;
            showOnWindowsOpen = false;
            openOnOverview = false;
            visible = true;
            popupGapsAuto = true;
            popupGapsManual = 4;
            maximizeDetection = true;
            useOverlayLayer = false;
            scrollEnabled = true;
            scrollXBehavior = "column";
            scrollYBehavior = "workspace";
            shadowIntensity = 0;
            shadowOpacity = 60;
            shadowColorMode = "default";
            shadowCustomColor = "#000000";
            clickThrough = false;
            hoverPopouts = false;
            hoverPopoutDelay = 150;
          }
        ];
        desktopClockCustomColor = {
          r = 1;
          g = 1;
          b = 1;
          a = 1;
          hsvHue = -1;
          hsvSaturation = 0;
          hsvValue = 1;
          hslHue = -1;
          hslSaturation = 0;
          hslLightness = 1;
          valid = true;
        };
        systemMonitorCustomColor = {
          r = 1;
          g = 1;
          b = 1;
          a = 1;
          hsvHue = -1;
          hsvSaturation = 0;
          hsvValue = 1;
          hslHue = -1;
          hslSaturation = 0;
          hslLightness = 1;
          valid = true;
        };
        configVersion = 16;
      };
    };
  };
}
