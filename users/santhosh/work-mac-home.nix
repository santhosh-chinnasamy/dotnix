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
      eza
      bat
      direnv
      devenv
      comma
      ripgrep
      claude-code
      _1password-cli
      curl
      wget
    ];
  };

  programs = {

    zsh = {
      enable = true;
      enableCompletion = true;
      initContent = ''
       eval "$(${pkgs.starship}/bin/starship init zsh)"
       #eval "$(direnv hook zsh)"
       eval "$(devenv hook zsh)"
       '';
    };

    home-manager.enable = true;
    neovim.enable = true;
    lazyvim.enable = true;
    direnv ={
      enable = true;
       nix-direnv.enable = true;
    };

    git = {
      enable = true;
      settings = {
        user = {
          name = "Santhosh C";
          email = "csesanthosh15@gmail.com";
        };
      };
    };

    starship = {
      enable = true;
      enableZshIntegration = true;
      settings = {
        character = {
          success_symbol = "[](bold green) ";
          error_symbol = "[✗](bold red) ";
        };
      };
    };
  };
}
