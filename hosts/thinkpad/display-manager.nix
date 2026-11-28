{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.custom.displayManager;

  # greetd runs the greeter as its own system user, so point tuigreet at the
  # system session files explicitly instead of relying on XDG_DATA_DIRS.
  # Only Wayland sessions are installed (no X11 session files).
  sessionDirs = "/run/current-system/sw/share/wayland-sessions";
in
{
  # Switching this option takes effect at the next boot: on a live switch the
  # old display manager is stopped (taking the running session with it). Use
  # `sudo nixos-rebuild boot --flake .#thinkpad` and reboot instead.
  options.custom.displayManager.session = lib.mkOption {
    type = lib.types.enum [
      "gdm"
      "greetd"
    ];
    default = "gdm";
    description = ''
      Login screen:

      - `"gdm"`: GNOME Display Manager. Password at boot; fingerprint is only
        used for re-authentication (lock/unlock) since GNOME 51.
      - `"greetd"`: greetd with the tuigreet TUI greeter. Fingerprint or
        password at boot (fprintd runs first, with a password fallback).
    '';
  };

  config = lib.mkMerge [
    (lib.mkIf (cfg.session == "gdm") {
      services.displayManager.gdm.enable = true;
    })

    (lib.mkIf (cfg.session == "greetd") {
      services.greetd = {
        enable = true;
        # Keep systemd boot messages off the TUI.
        useTextGreeter = true;

        settings.default_session = {
          # If tuigreet dies instantly (e.g. an unsupported flag after an
          # upgrade), fall back to greetd's own minimal greeter so the
          # console still allows a login and repair.
          command =
            (lib.concatStringsSep " " [
              "${pkgs.tuigreet}/bin/tuigreet"
              "--time"
              "--remember"
              "--remember-user-session"
              "--sessions ${sessionDirs}"
            ])
            + " || ${pkgs.greetd}/bin/agreety --cmd ${pkgs.bashInteractive}/bin/bash";
          user = "greeter";
        };
      };

      # Same-generation escape hatch: an extra boot-menu entry that runs GDM
      # instead, so a working greeter survives even aggressive cleanup of old
      # generations. Boot into it; do not live-switch into a specialisation.
      specialisation.gdm-fallback.configuration.custom.displayManager.session = lib.mkForce "gdm";

      # Keep a failed greeter from hot-looping on the VT.
      systemd.services.greetd.serviceConfig.RestartSec = "1s";

      # greetd authenticates through the `login` PAM stack. fprintd is part of
      # it via services.fprintd.enablePam (GDM disabled means it is not forced
      # off); shorten the probe so a typed password is not delayed by the
      # module's long default timeout.
      security.pam.services.login.fprintAuth = lib.mkForce true;
      security.pam.services.login.rules.auth.fprintd.settings.timeout = 10;
    })
  ];
}
