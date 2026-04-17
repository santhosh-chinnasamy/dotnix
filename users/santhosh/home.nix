{
  pkgs,
  nixpkgs,
  inputs,
  ...
}:
{
  home.username = "santhosh";
  home.homeDirectory = "/home/santhosh";
  home.stateVersion = "25.11";

  home.packages = with pkgs; [
    telegram-desktop
    ghostty
    kitty
    #waybar
    #   hyprpanel

    awww
    rofi
    libnotify
    brightnessctl
    networkmanagerapplet
  ];

  programs.git = {
    enable = true;
    userName = "Santhosh C";
    userEmail = "csesanthosh15@gmail.com";
  };

  programs.home-manager.enable = true;
  fonts.fontconfig.enable = true;

  programs.hyprpanel = {
    enable = false;

    settings = {
      theme = "nord";
      layout = {
        "0" = {
          left = [
            "dashboard"
            "workspaces"
            "windowtitle"
          ];
          middle = [ "media" ];
          right = [
            "volume"
            "network"
            "bluetooth"
            "systray"
            "clock"
            "notifications"
          ];
        };

        "1" = {
          left = [
            "dashboard"
            "workspaces"
            "windowtitle"
          ];
          middle = [ "media" ];
          right = [
            "volume"
            "clock"
            "notifications"
          ];
        };

        "2" = {
          left = [
            "dashboard"
            "workspaces"
            "windowtitle"
          ];
          middle = [ "media" ];
          right = [
            "volume"
            "clock"
            "notifications"
          ];
        };
      };
    };
  };
  imports = [
    ./modules/hyprland.nix
    ./modules/noctalia.nix
  ];
}
