# 1password.nix
{ pkgs, inputs, ... }:

{
  imports = [
    inputs._1password-shell-plugins.hmModules.default
  ];

  # Install 1Password CLI
  home.packages = with pkgs; [
    _1password-cli
    _1password-gui
  ];

  # Enable 1Password Shell Plugins (if using plugins)
  programs = {
    _1password-shell-plugins = {
      enable = true;
      # plugins = with pkgs; [ gh ]; # Example
    };
  };
}
