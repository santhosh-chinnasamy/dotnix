{
  config,
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    ./modules/common.nix
    ./modules/shell.nix
    ./modules/hyprland.nix
    ./modules/dms.nix
    ./modules/noctalia.nix
    ./modules/1password.nix
    ./modules/zen.nix
  ];

  home = {
    username = "santhosh";
    homeDirectory = "/home/santhosh";
    stateVersion = "25.11";
    sessionVariables = {
      XDG_DATA_DIRS = "$XDG_DATA_DIRS:$HOME/.local/share/flatpak/exports/share";
    };

    pointerCursor = {
      enable = false;
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
      libnotify
      brightnessctl
      networkmanagerapplet
      gh
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
      localsend
      t3code
      cursor-cli
      tailscale
      opencode
      opencode-desktop
    ];
  };

  fonts.fontconfig.enable = true;
  gtk = {
    enable = true;
    gtk4.theme = config.gtk.theme;
  };

  programs.hyprlock.enable = true;

  services.hyprpaper.enable = true;

  # Active Wayland desktop shell: "dms" | "noctalia" | "none"
  custom.desktop.shell = "dms";
}
