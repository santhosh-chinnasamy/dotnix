{ pkgs, ... }:
{
  home.username = "lisasri";
  home.homeDirectory = "/home/lisasri";
  home.stateVersion = "25.11";
  home.sessionVariables = {
    XDG_DATA_DIRS = "$XDG_DATA_DIRS:$HOME/.local/share/flatpak/exports/share";
  };

  home.packages = with pkgs; [
    gnome-tweaks
    ghostty
  ];

  programs.home-manager.enable = true;

  fonts.fontconfig.enable = true;
}
