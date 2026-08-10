{
  config,
  pkgs,
  inputs,
  ...
}:

{
  imports = [
    inputs.lazyvim.homeManagerModules.default
  ];

  home = {
    username = "santhoshc";
    homeDirectory = "/Users/santhoshc";
    stateVersion = "25.11";

    # Import shared aliases from personal configuration
    shellAliases = import ./config/aliases.nix;

    # CLI packages managed by Home Manager
    packages = with pkgs; [
      lazygit
      nil
      statix
      nixfmt
    ];
  };

  programs = {
    zsh = {
      enable = true;
      initContent = ''
        eval "$(${pkgs.starship}/bin/starship init zsh)"
      '';
    };

    home-manager.enable = true;
    neovim.enable = true;
    lazyvim.enable = true;

    starship = {
      enable = true;
      settings = {
        character = {
          success_symbol = "[](bold green) ";
          error_symbol = "[✗](bold red) ";
        };
      };
    };
  };
}
