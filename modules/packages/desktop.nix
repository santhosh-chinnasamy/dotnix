{ pkgs, ...}: {
  environment.systemPackages = with pkgs; [
  firefox
  vlc
  libreoffice-fresh
  vscodium
  ];

  programs.hyprland = {
      enable = true;
      xwayland.enable = true;
    };
}
