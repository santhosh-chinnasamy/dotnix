{ pkgs, inputs, ... }:
{
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
    statix
    fd
    eza
    just
    comma
  ];

  # set default editor as neovim
  environment.variables.EDITOR = "nvim";

  environment.etc = {
    "1password/custom_allowed_browsers" = {
      text = ''
        firefox
        zen
      '';
      mode = "0755";
    };
  };

}
