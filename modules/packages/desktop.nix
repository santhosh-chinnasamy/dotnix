{ pkgs, ...}: {
  environment.systemPackages = with pkgs; [
  firefox
  vlc
  libreoffice-fresh
  vscodium
  ];
}
