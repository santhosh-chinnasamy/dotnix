{
  inputs,
  pkgs,
  ...
}:
let
  snappy = inputs.snappy-switcher.packages.${pkgs.stdenv.hostPlatform.system}.default;
in
{
  home.packages = [ snappy ];

  xdg.configFile."snappy-switcher/config.ini".text = ''
    [general]
    # overview = one card per window. context groups tiled windows of the same app.
    mode = overview
    follow_monitor = true
    show_workspace_badge = true
    sticky_mode = false
    ignore_pinned = true
    ignore_special = true

    [theme]
    name = catppuccin-mocha.ini
    border_width = 1
    card_border_width = 2
    corner_radius = 12

    [layout]
    card_width = 145
    card_height = 135
    card_gap = 10
    padding = 10
    max_cols = 5
    icon_size = 48
    icon_radius = 12

    [icons]
    theme = Adwaita
    fallback = hicolor
    show_letter_fallback = true

    [custom_icons]
    com.mitchellh.ghostty = com.mitchellh.ghostty
    com.t3tools.T3Code = t3code

    [font]
    family = Sans
    weight = Bold
    title_size = 11
    icon_letter_size = 22
  '';

  # Package installs themes under $out/share; the binary also searches this dir first.
  xdg.configFile."snappy-switcher/themes".source = "${snappy}/share/snappy-switcher/themes";

  systemd.user.services.snappy-switcher = {
    Unit = {
      Description = "Snappy Switcher window switcher";
      After = [ "hyprland-session.target" ];
      PartOf = [ "hyprland-session.target" ];
      ConditionEnvironment = [
        "WAYLAND_DISPLAY"
        "HYPRLAND_INSTANCE_SIGNATURE"
      ];
    };
    Service = {
      Type = "simple";
      ExecStart = "${snappy}/bin/snappy-switcher --daemon";
      ExecStop = "${snappy}/bin/snappy-switcher quit";
      Restart = "on-failure";
      RestartSec = "2s";
    };
    Install.WantedBy = [ "hyprland-session.target" ];
  };
}
