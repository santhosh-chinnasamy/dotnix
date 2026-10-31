# Linux 1Password GUI + shell plugins. CLI is installed via common.nix.
{ pkgs, inputs, ... }:

{
  imports = [
    inputs._1password-shell-plugins.hmModules.default
  ];

  home.packages = with pkgs; [
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
