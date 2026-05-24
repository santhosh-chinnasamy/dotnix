{
  config,
  pkgs,
  inputs,
  ...
}:
{
  home = {
    username = "santhosh";
    homeDirectory = "/home/santhosh";
    stateVersion = "25.11";

    shellAliases = import ./config/aliases.nix;

    pointerCursor = {
      gtk.enable = true;
      x11.enable = true;
      name = "catppuccin-mocha-dark-cursors";
      package = pkgs.catppuccin-cursors.mochaDark;
      size = 24;
      hyprcursor.enable = true;
    };

    packages = with pkgs; [
      telegram-desktop
      ghostty
      kitty
      lazygit
      libnotify
      brightnessctl
      networkmanagerapplet
      gh
      gemini-cli
      hyprlock
      hyprpolkitagent
      grimblast
      hyprpaper
      audacity
    ];
  };

  fonts.fontconfig.enable = true;
  gtk = {
    enable = true;
    gtk4.theme = config.gtk.theme;
  };
  programs = {
    bash.enable = true;
    git = {
      enable = true;
      userName = "Santhosh C";
      userEmail = "csesanthosh15@gmail.com";
    };

    home-manager.enable = true;
    hyprlock = {
      enable = true;
    };
    #direnv.enable = true;
    #nix-index.enable = true;
  };

  services.hyprpaper.enable = true;

  imports = [
    ./modules/hyprland.nix
    ./modules/noctalia.nix
    ./modules/1password.nix
    ./modules/zen.nix
  ];
}
