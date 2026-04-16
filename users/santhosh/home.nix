{ pkgs, ...}: {
    home.username = "santhosh";
    home.homeDirectory = "/home/santhosh";
    home.stateVersion = "25.11";

    home.packages = with pkgs; [
    telegram-desktop
    ghostty
    kitty
    waybar
    awww
    rofi
    libnotify
    brightnessctl
    networkmanagerapplet
    ];
    
    programs.git = {
        enable = true;
        userName = "Santhosh C";
        userEmail = "csesanthosh15@gmail.com";
      };

    programs.home-manager.enable = true;
    fonts.fontconfig.enable = true;

# Hyprland config
    wayland.windowManager.hyprland = {
      enable = true;
      settings ={
          "$mainMod" = "SUPER";
          monitor = ",preferred,auto,1.25";

          exec-once = [
          "waybar"
          "awww init"
          ];

          input = {
              kb_layout = "us";
              follow_mouse = 1;
              touchpad = {
                  natural_scroll = true;
                  tap-to-click = true;
                  drag_lock = true;
                };
                sensitivity = 0; # -1.0 to 1.0 (0  means no modificatoins)
            };

          bind = [
          "$mainMod, Return, exec, ghostty"
          "$mainMod, W, killactive"
          "$mainMod, Q, exit"
          "$mainMod, E, exec, nautilus"
          "$mainMod, Space, exec, rofi -show drun"
          "$mainMod, V, togglefloating"
          "$mainMod, P, pseudo"
          "$mainMod, J, togglesplit"


          # Focus Movement
          "$mainMod, left, movefocus, l"
          "$mainMod, right, movefocus, r"
          "$mainMod, up, movefocus, u"
          "$mainMod, down, movefocus, d"

          # Workspaces
          "$mainMod, 1, workspace, 1"
          "$mainMod, 2, workspace, 2"
          "$mainMod, 3, workspace, 3"
          "$mainMod, 4, workspace, 4"
        
          # Move active window to workspace
          "$mainMod SHIFT, 1, movetoworkspace, 1"
          "$mainMod SHIFT, 2, movetoworkspace, 2"
          ];

          general = {
              layout = "dwindle";
            };
          
          decoration = {
              rounding = 2;
              blur = { enabled = true; size = 3; passes = 0;};
            };

            drop_shadow = false;
            shadow_range = 4;
            shadow_renderer_power = 3;
            "col.shadow" = "rgba(1a1a1aee)";
        };
      };
  }
