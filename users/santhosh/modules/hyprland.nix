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
                  env = GDK_BACKEND,wayland

                  monitor = ,preferred,auto,1.5

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
                  bind = $mainMod, U, togglefloating
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
                  bind = $mainMod, 5, workspace, 5
                  bind = $mainMod SHIFT, 6, movetoworkspace, 6
                  bind = $mainMod SHIFT, 7, movetoworkspace, 7
                  bind = $mainMod SHIFT, 8, movetoworkspace, 8
                  bind = $mainMod SHIFT, 9, movetoworkspace, 9
                  bind = $mainMod SHIFT, 0, movetoworkspace, 10
                  
                  bind = $mainMod SHIFT, 1, movetoworkspace, 1
                  bind = $mainMod SHIFT, 2, movetoworkspace, 2
                  bind = $mainMod SHIFT, 3, movetoworkspace, 3
                  bind = $mainMod SHIFT, 4, movetoworkspace, 4
                  bind = $mainMod SHIFT, 5, movetoworkspace, 5
                  bind = $mainMod SHIFT, 6, movetoworkspace, 6
                  bind = $mainMod SHIFT, 7, movetoworkspace, 7
                  bind = $mainMod SHIFT, 8, movetoworkspace, 8
                  bind = $mainMod SHIFT, 9, movetoworkspace, 9
                  bind = $mainMod SHIFT, 0, movetoworkspace, 10

                  ## system key bind
                  bind = , XF86AudioRaiseVolume, exec, $ipc volume increase
                  bind = , XF86AudioLowerVolume, exec, $ipc volume decrease
                  bind = , XF86AudioMute, exec, $ipc volume muteOutput
                  bind = , XF86AudioMicMute, exec, $ipc volume muteInput

                  bind = , XF86MonBrightnessUp, exec, brightnessctl set +5%
                  bind = , XF86MonBrightnessDown, exec, brightnessctl set 5%-

                  bind = , XF86AudioPlay, exec, $ipc media playPause
                  bind = , XF86AudioNext, exec, $ipc media next
                  bind = , XF86AudioPrev, exec, $ipc media previous

                  # clipboard
                  bind = SHIFT, Print, exec, grimblast copy screen
                  bind = SHIFT, code:634, exec, grimblast copy area

                  # Copy / Paste
                  bindd = SUPER, C, Universal copy, sendshortcut, CTRL, Insert,
                  bindd = SUPER, V, Universal paste, sendshortcut, SHIFT, Insert,
                  bindd = SUPER, X, Universal cut, sendshortcut, CTRL, X,


                  # full screen + notify
                  bind = , Print, exec, sh -c 'FILE=~/Pictures/Screenshots_$(date +%Y-%m-%d_%H-%M-%S).png && grimblast save screen $FILE && notify-send "Screenshot saved"'

                  # area select + notify
                  bind = , code:634, exec, sh -c 'FILE=~/Pictures/Screenshots_$(date +%Y-%m-%d_%H-%M-%S).png && grimblast save area $FILE && notify-send "Screenshot saved"'

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
}
