{
  # hyprlock: the single in-session lock screen.
  #
  # GDM stays the boot/login greeter. Every in-session lock path — Super+Ctrl+L,
  # hypridle's idle timeout and suspend hook, and DMS's power-menu lock
  # (customPowerActionLock) — lands here. Fingerprint support comes from the
  # fprintd-first PAM service in hosts/thinkpad/configuration.nix
  # (pam.services.hyprlock).
  programs.hyprlock = {
    enable = true;

    settings = {
      general.hide_cursor = true;

      background = [
        {
          monitor = "";
          # Blur the live desktop: always matches the wallpaper DMS sets and
          # the current monitor layout, with no extra state to maintain.
          path = "screenshot";
          color = "rgba(30,30,46,1.0)";
          blur_passes = 3;
          blur_size = 8;
        }
      ];

      label = [
        {
          monitor = "";
          text = "cmd[update:1000] echo \"$(date +'%I:%M %p')\"";
          color = "rgba(205,214,244,1.0)";
          font_family = "JetBrainsMono Nerd Font";
          font_size = 96;
          position = "0, 120";
          halign = "center";
          valign = "center";
        }
        {
          monitor = "";
          text = "cmd[update:60000] echo \"$(date +'%A, %B %d')\"";
          color = "rgba(166,173,200,1.0)";
          font_family = "JetBrainsMono Nerd Font";
          font_size = 22;
          position = "0, 40";
          halign = "center";
          valign = "center";
        }
      ];

      input-field = [
        {
          monitor = "";
          size = "260, 50";
          position = "0, -120";
          dots_center = true;
          fade_on_empty = false;
          outline_thickness = 2;
          placeholder_text = "Password or fingerprint";
          fail_text = "Try again — password or fingerprint";
          font_family = "JetBrainsMono Nerd Font";
          font_color = "rgba(205,214,244,1.0)";
          inner_color = "rgba(49,50,68,0.85)";
          outer_color = "rgba(24,24,37,1.0)";
        }
      ];
    };
  };
}
