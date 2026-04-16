{ pkgs, ...}: {
  environment.systemPackages = with pkgs; [
  neovim
  git
  curl
  wget
  bat
  ripgrep
  ];

# set default editor as neovim
environment.variables.EDITOR="nvim";
}
