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
    ./modules/hypridle.nix
    ./modules/hyprlock.nix
    ./modules/kanshi.nix
    ./modules/hex.nix
    ./modules/quake-console.nix
    ./modules/desktop-extras.nix
    ./modules/electron-keyring.nix
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
      code-cursor
      cursor-cli
      tailscale
      opencode
      opencode-desktop
      inputs.grok-bot.packages.${pkgs.system}.default
      # inputs.hex.packages.${pkgs.system}.default
    ];
  };

  fonts.fontconfig.enable = true;
  gtk = {
    enable = true;
    gtk4.theme = config.gtk.theme;
  };

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
      # Retry through the login window where the compositor is still starting,
      # instead of burning the default start limit (5 failures in 10s).
      StartLimitIntervalSec = 30;
      StartLimitBurst = 10;
    };
    Service = {
      ExecStart = "${pkgs.hyprpolkitagent}/libexec/hyprpolkitagent";
      Slice = "session.slice";
      TimeoutStopSec = "5s";
      Restart = "on-failure";
      RestartSec = "1";
    };
    Install.WantedBy = [ "hyprland-session.target" ];
  };

  # Active Wayland desktop shell: "dms" | "noctalia" | "none"
  custom.desktop.shell = "dms";
  custom.desktop.quakeConsole.terminal = "ghostty";
}
