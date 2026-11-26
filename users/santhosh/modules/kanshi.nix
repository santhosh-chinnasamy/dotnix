_: {
  # Declarative output profiles applied on hotplug.
  #
  # Kanshi only considers a profile when its number of outputs equals the
  # number of connected heads, and it applies the first matching profile in
  # order. Keep named locations first, the wildcard fallback after them, and
  # undocked last.
  services.kanshi = {
    enable = true;
    systemdTarget = "hyprland-session.target";
    settings = [
      # Named location profiles (home / office / college) go here, before the
      # wildcard fallback, once their monitor identities are recorded with
      # `hyprctl monitors -j` at that location.
      #
      # Ad-hoc fallback for conference stages and community venues: the laptop
      # panel plus any unknown external display. kanshi matches "*" against the
      # remaining head, so this only activates when exactly one extra output is
      # connected.
      {
        profile = {
          name = "adhoc";
          outputs = [
            {
              criteria = "eDP-1";
              position = "0,0";
              scale = 2.0;
            }
            {
              criteria = "*";
              position = "1440,0";
              scale = 1.0;
            }
          ];
        };
      }
      {
        profile = {
          name = "undocked";
          outputs = [
            {
              criteria = "eDP-1";
              position = "0,0";
              scale = 2.0;
            }
          ];
        };
      }
    ];
  };
}
