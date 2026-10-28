{
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    inputs.lazyvim.homeManagerModules.default
    ./starship.nix
  ];

  home = {
    shellAliases = import ../config/aliases.nix;

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
      glab
    ];
  };

  programs = {
    home-manager.enable = true;
    neovim.enable = true;
    lazyvim.enable = true;

    direnv = {
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

    zsh = {
      enable = true;
      enableCompletion = true;
      syntaxHighlighting.enable = true;
      oh-my-zsh = {
        enable = true;
        plugins = [ "git" ];
      };
      initContent = ''
        eval "$(devenv hook zsh)"
      '';
    };
  };
}
