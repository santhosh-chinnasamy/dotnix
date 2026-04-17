{config, pkgs, ... }: {
  wayland.windowManager.hyprland = {
  enable = true;

  extraConfig = ''
    $mainMod = SUPER

    monitor = ,preferred,auto,1.33

    exec-once = awww init
    exec-once = hyprpanel

    input {
      kb_layout = us
      follow_mouse = 1

      touchpad {
        natural_scroll = true
        tap-to-click = true
        drag_lock = true
      }

      sensitivity = 0
    }

    gesture = 3, horizontal, workspace

    bind = $mainMod, Return, exec, ghostty
    bind = $mainMod, W, killactive
    bind = $mainMod, Q, exit
    bind = $mainMod, E, exec, nautilus
    bind = $mainMod, Space, exec, rofi -show drun
    bind = $mainMod, V, togglefloating
    bind = $mainMod, P, pseudo
    bind = $mainMod, J, togglesplit
    bind = $mainMod, F, fullscreen

    bind = $mainMod, left, movefocus, l
    bind = $mainMod, right, movefocus, r
    bind = $mainMod, up, movefocus, u
    bind = $mainMod, down, movefocus, d

    bind = $mainMod, 1, workspace, 1
    bind = $mainMod, 2, workspace, 2
    bind = $mainMod, 3, workspace, 3
    bind = $mainMod, 4, workspace, 4

    bind = $mainMod SHIFT, 1, movetoworkspace, 1
    bind = $mainMod SHIFT, 2, movetoworkspace, 2

    general {
      layout = dwindle
    }

    decoration {
      rounding = 2

      blur {
        enabled = true
        size = 3
        passes = 0
      }
    }

    drop_shadow = false
    shadow_range = 4
    shadow_render_power = 3
    col.shadow = rgba(1a1a1aee)
  '';
};

} 
