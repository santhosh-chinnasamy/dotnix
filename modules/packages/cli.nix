{ pkgs, ... }:
{
  # Linux system CLI: host/build/hardware tools. Cross-platform user CLI lives in
  # users/santhosh/modules/common.nix.
  environment.systemPackages = with pkgs; [
    neovim
    git
    gcc
    gnumake
    gdb
    wl-clipboard
    tree-sitter
    xdg-utils
    openssl
    openssl.dev
    fd
    just
    wlr-randr
    usbutils
    picocom
    docker-compose
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
