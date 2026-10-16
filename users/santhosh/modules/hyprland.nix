{
  config,
  inputs,
  pkgs,
  ...
}:
{
  # 1. Disable the module so it STOPS creating hyprland.conf
  wayland.windowManager.hyprland.enable = false;

  # 2. Install the Hyprland package manually instead
  home.packages = [ pkgs.hyprland ];

  # 3. Deploy ONLY your Lua configuration
  xdg.configFile."hypr" = {
    source = ./hypr;
    recursive = true;
  };
}
