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
    ./modules/walker.nix
    ./modules/snappy-switcher.nix
    ./modules/voxtype.nix
    ./modules/desktop-extras.nix
  ];

  home = {
    username = "santhosh";
    homeDirectory = "/home/santhosh";
    stateVersion = "25.11";
    sessionVariables = {
      XDG_DATA_DIRS = "$XDG_DATA_DIRS:$HOME/.local/share/flatpak/exports/share";
      # DMS registers its own polkit agent; that blocks hyprpolkitagent. Prefer
      # hyprpolkitagent so prompts always show (fingerprint / password).
      DMS_DISABLE_POLKIT = "1";
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
      inputs.grok-bot.packages.${pkgs.system}.default
      # inputs.hex.packages.${pkgs.system}.default
    ];

    # VS Code: use gnome-keyring via libsecret (fixes "weaker encryption").
    file.".vscode/argv.json".text = builtins.toJSON {
      "password-store" = "gnome-libsecret";
      "enable-crash-reporter" = false;
    };
  };

  fonts.fontconfig.enable = true;
  gtk = {
    enable = true;
    gtk4.theme = config.gtk.theme;
  };

  programs.hyprlock.enable = true;

  services.hyprpaper.enable = true;

  # Polkit auth agent (fingerprint / password popup for pkexec & privileged apps).
  # Must define ExecStart: a HM-only Install/Unit override replaces the package
  # unit in ~/.config/systemd/user and leaves a broken service with no ExecStart.
  systemd.user.services.hyprpolkitagent = {
    Unit = {
      Description = "Hyprland Polkit Authentication Agent";
      After = [ "graphical-session.target" ];
      PartOf = [ "graphical-session.target" ];
      ConditionEnvironment = "WAYLAND_DISPLAY";
    };
    Service = {
      ExecStart = "${pkgs.hyprpolkitagent}/libexec/hyprpolkitagent";
      Slice = "session.slice";
      TimeoutStopSec = "5s";
      Restart = "on-failure";
    };
    Install.WantedBy = [ "hyprland-session.target" ];
  };

  # Codium shares the same keyring fix as VS Code (~/.vscode/argv.json above).
  xdg.configFile."VSCodium/argv.json".text = builtins.toJSON {
    "password-store" = "gnome-libsecret";
    "enable-crash-reporter" = false;
  };

  # Active Wayland desktop shell: "dms" | "noctalia" | "none"
  custom.desktop.shell = "dms";
}
