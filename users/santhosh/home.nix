{
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
    ];
  };

  fonts.fontconfig.enable = true;
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

  imports = [
    ./modules/hyprland.nix
    ./modules/noctalia.nix
    ./modules/1password.nix
    ./modules/zen.nix
  ];
}
