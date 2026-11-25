_: {
  # Idle lock without suspending: the session locks, but OpenCode, agents and
  # Tailscale keep running (locking is not sleeping).
  services.hypridle = {
    enable = true;
    systemdTarget = "hyprland-session.target";
    settings = {
      general = {
        # Avoid stacking multiple hyprlock instances.
        lock_cmd = "pidof hyprlock || hyprlock";
        # Lock (don't suspend) before sleep.
        before_sleep_cmd = "loginctl lock-session";
        after_sleep_cmd = "hyprctl dispatch dpms on";
        # Respect video players' idle inhibitors (fullscreen playback).
        ignore_dbus_inhibit = false;
      };
      listener = [
        {
          # 5 minutes: lock the session.
          timeout = 300;
          on-timeout = "loginctl lock-session";
        }
        {
          # 10 minutes: turn the display off (machine stays awake and reachable).
          timeout = 600;
          on-timeout = "hyprctl dispatch dpms off";
          on-resume = "hyprctl dispatch dpms on";
        }
      ];
    };
  };
}
