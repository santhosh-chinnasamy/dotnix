{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    firefox
    vlc
    libreoffice-fresh
    vscodium
    ## Manage displays (extend, mirror)
    wdisplays
  ];

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gnome
      xdg-desktop-portal-hyprland
    ];
  };

  fonts = {
    packages = with pkgs; [ nerd-fonts.jetbrains-mono ];

    fontconfig.defaultFonts = {
      monospace = [ "JetBrainsMono Nerd Font" ];
    };
  };
}
