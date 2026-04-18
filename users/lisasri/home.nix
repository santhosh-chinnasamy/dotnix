{ pkgs, ... }:
{
  home.username = "lisasri";
  home.homeDirectory = "/home/lisasri";
  home.stateVersion = "25.11";

  home.packages = with pkgs; [
    gnome-tweaks
    ghostty
  ];

  programs.home-manager.enable = true;

  fonts.fontconfig.enable = true;
}
