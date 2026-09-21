{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
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

      plugins = {
        calculator = {
          enable = true;
          src = pkgs.fetchFromGitHub {
            owner = "rochacbruno";
            repo = "DankCalculator";
            rev = "1db5865419a40a33171a475855a59e0b8bf7187f";
            hash = "sha256-j8C62+sevr6b+akzVSAqUVysIhb6Vbr8jnWcTXeOtE8=";
          };
          settings = {
            trigger = "=";
          };
        };
        modernClock = {
          enable = true;
          src = pkgs.fetchFromGitHub {
            owner = "beefsizzle";
            repo = "ModernClockDMS";
            rev = "0d11d9fb560547a2589d59e456598f7c94847bae";
            hash = "sha256-cD8Ho8PG8GqRBPFtgub02uIMgXVsd0P8AzTNuVYccEk=";
          };
        };
      };

      settings = {
        # Theming & Appearance
        currentThemeName = "dynamic";
        currentThemeCategory = "dynamic";
        matugenScheme = "scheme-neutral";
        widgetBackgroundColor = "sth";
        widgetColorMode = "colorful";
        cornerRadius = 12;
        hyprlandLayoutRadiusOverride = 12;
        showWeekNumber = true;
        clockFormat = "12h";

        # Control Center
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

        # Workspaces & Launcher
        showWorkspaceIndex = true;
        showWorkspaceApps = true;
        workspaceFollowFocus = true;
        showOccupiedWorkspacesOnly = true;
        appIdSubstitutions = [ ];
        centeringMode = "geometric";
        sortAppsAlphabetically = true;
        spotlightSectionViewModes = {
          apps = "grid";
        };
        dankLauncherV2Size = "micro";
        launcherLogoMode = "os";

        # System & Battery
        weatherEnabled = false;
        soundLogin = true;
        batteryChargeLimit = 80;
        batteryNotifyChargeLimit = true;
        batteryNotifyLow = true;
        terminalsAlwaysDark = true;
        lockPamExternallyManaged = true;

        # Island & OSD
        dankIslandHomeCompactTight = true;
        dankIslandSatelliteBackground = true;
        osdAlwaysShowValue = true;
        osdPosition = 4;
        osdPowerProfileEnabled = true;
        screenPreferences = {
          wallpaper = [ "all" ];
        };
        displayProfileAutoSelect = true;

        # Typography & Cursor
        fontFamily = "JetBrainsMono NF";
        monoFontFamily = "JetBrainsMono Nerd Font";
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

        # Main Bar Configuration
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
                mediaSize = 0;
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
                id = "colorPicker";
                enabled = true;
              }
              {
                id = "notepadButton";
                enabled = true;
              }
              {
                id = "controlCenterButton";
                enabled = true;
              }
              {
                id = "privacyIndicator";
                enabled = true;
              }
              {
                id = "powerMenuButton";
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
            removeWidgetPadding = false;
            widgetPadding = 8;
            gothCornersEnabled = false;
            gothCornerRadiusOverride = false;
            gothCornerRadiusValue = 12;
            borderEnabled = false;
            borderColor = "surfaceText";
            borderOpacity = 1;
            borderThickness = 1;
            widgetOutlineEnabled = false;
            widgetOutlineColor = "surfaceText";
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
            # hoverPopouts = false;
            # hoverPopoutDelay = 150;
          }
        ];

        # Custom Colors
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

        # Desktop Widget Instances
        desktopWidgetInstances = [
          {
            id = "dw_1788370747512_0r9vaekia";
            widgetType = "modernClock";
            name = "Modern Clock";
            enabled = true;
            config = {
              displayPreferences = [
                "all"
              ];
              useThemeColors = true;
              timeColor = "#2196f3";
              dateColor = "#03a9f4";
              dayColor = "#03a9f4";
            };
          }
        ];

        # Built-in Plugin Triggers
        builtInPluginSettings = {
          dms_settings_search = {
            trigger = "?";
          };
          dms_clipboard_search = {
            trigger = "cb";
          };
          dms_power = {
            trigger = "pw";
          };
          dms_qr_generator = {
            trigger = "qrg";
          };
        };

        configVersion = 16;
      };
    };
  };
}
