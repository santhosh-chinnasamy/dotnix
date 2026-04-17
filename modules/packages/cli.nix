{ pkgs, ...}: {
  environment.systemPackages = with pkgs; [
  neovim
  git
  curl
  wget
  bat
  ripgrep
  gcc
  gnumake
  gdb
  wl-clipboard
  tree-sitter
  direnv
  xdg-utils
  openssl
  openssl.dev
  ];

# set default editor as neovim
environment.variables.EDITOR="nvim";
fonts.packages = with pkgs; [nerd-fonts.jetbrains-mono];
}
