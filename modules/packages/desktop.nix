{ pkgs, inputs, ... }:
{
  environment.systemPackages = with pkgs; [
    firefox
    vlc
    libreoffice
    vscodium
    ## Manage displays (extend, mirror)
    wdisplays
    opencode-desktop
  ];

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
    # Use the portal built from the same Hyprland flake revision: the nixpkgs
    # 1.5.0 build lags behind and its screencopy/picker bugs break portal
    # capture (Annotate, portal recorders, browser screen sharing).
    portalPackage =
      inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
  };

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gnome
    ];
  };

  fonts = {
    packages = with pkgs; [ nerd-fonts.jetbrains-mono ];

    fontconfig.defaultFonts = {
      monospace = [ "JetBrainsMono Nerd Font" ];
    };
  };
}
