{ config, pkgs, inputs, ... }:

{
  home = {
    username = "santhoshc";            # Match your macOS short name (`whoami`)
    homeDirectory = "/Users/santhoshc"; # macOS user home directory
    stateVersion = "25.11";

    # Share existing aliases with Thinkpad
    shellAliases = import ./config/aliases.nix;

    # Cross-platform CLI & GUI tools that work on macOS
    packages = with pkgs; [
      #ghostty
      lazygit
      vscode
      starship
    ];
  };

  programs = {
    zsh.enable = true;
    home-manager.enable = true;
    starship = {
        enable= true;
         
         settings = {
          character = {
        success_symbol = "[➜](bold blue)";
        error_symbol = "[➜](bold red)";
      };
         };
      };

    # Work-specific Git configuration
    #git = {
     # enable = true;
      #userName = "Santhosh C";
      #userEmail = "santhosh@company.com"; # Use work email here
    #};
  };

  # Import only cross-platform modules (e.g. 1Password if compatible)
 # imports = [
  #];
}
