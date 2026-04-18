{
  config,
  inputs,
  pkgs,
  ...
}:
{
  wayland.windowManager.hyprland = {
    enable = true;

    extraConfig = ''
                  $mainMod = SUPER
                  $ipc = noctalia-shell ipc call

                  env = XDG_CURRENT_DESKTOP,Hyprland
                  env = XDG_SESSION_TYPE,wayland
                  env = NIXOS_OZONE_WL,1
                  monitor = ,preferred,auto,1.25

                  input {
                    kb_layout = us
                    follow_mouse = 1

                    touchpad {
                      natural_scroll = true
                      tap-to-click = true
                      drag_lock = true
                    }

                    sensitivity = 0
                    accel_profile = flat
                  }

                  gesture = 3, horizontal, workspace

                  bind = $mainMod, Return, exec, ghostty
                  bind = $mainMod, B, exec, zen
                  bind = $mainMod, W, killactive
                  bind = $mainMod, Q, exit
                  bind = $mainMod, E, exec, nautilus
                  bind = $mainMod, Space, exec, $ipc launcher toggle
                  bind = ALT CTRL, C, exec, $ipc launcher clipboard
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
                    gaps_in = 5
                    gaps_out = 10
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
                  animations {
                      enabled = yes

                      bezier = easeOut, 0.25, 1, 0.5, 1

                      animation = windows, 1, 5, easeOut
                      animation = windowsOut, 1, 5, easeOut
                      animation = fade, 1, 5, easeOut
                      animation = workspaces, 1, 5, easeOut
                    }
                    misc {
        disable_hyprland_logo = true
        mouse_move_enables_dpms = true
      }
    '';
  };
  # https://chatgpt.com/s/t_69e275dfd3dc81918dfb117583d6a925
  # https://chatgpt.com/s/t_69e275bf7cbc8191afea0b5d95f44a02

}
