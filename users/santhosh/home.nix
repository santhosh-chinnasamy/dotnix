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
    sessionVariables = {
      XDG_DATA_DIRS = "$XDG_DATA_DIRS:$HOME/.local/share/flatpak/exports/share";
    };

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
      nushell
      vscode
      inputs.antigravity-nix.packages.${pkgs.stdenv.hostPlatform.system}.default
      inputs.antigravity-nix.packages.${pkgs.stdenv.hostPlatform.system}.google-antigravity-ide # IDE
      inputs.antigravity-nix.packages.${pkgs.stdenv.hostPlatform.system}.google-antigravity-cli # CLI
      inputs.codex-cli-nix.packages.${pkgs.stdenv.hostPlatform.system}.default
      inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default
      chromium
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

  # Active Wayland desktop shell: "dms" | "noctalia" | "none"
  custom.desktop.shell = "dms";

  imports = [
    ./modules/shell.nix
    ./modules/hyprland.nix
    ./modules/dms.nix
    ./modules/noctalia.nix
    ./modules/1password.nix
    ./modules/zen.nix
  ];
}
