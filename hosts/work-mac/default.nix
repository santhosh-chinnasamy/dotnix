{ pkgs, inputs, ... }: {
  imports = [
    inputs.mac-app-util.darwinModules.default
    inputs.home-manager.darwinModules.home-manager
  ];

  # Define the primary macOS user for Homebrew and system activation
  system.primaryUser = "santhoshc";

  # Enable Nix daemon & experimental features
  nix.enable = true;
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # System platform and unfree packages configuration
  nixpkgs.hostPlatform = "aarch64-darwin";
  nixpkgs.config.allowUnfree = true;

  # Enable system Zsh shell
  programs.zsh.enable = true;

  # Declarative Homebrew management for macOS GUI Applications
  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      upgrade = true;
      cleanup = "none";
    };
    casks = [
      "zoom"
      "slack"
      "visual-studio-code"
    ];
  };

  # Define system user matching `whoami`
  users.users.santhoshc = {
    name = "santhoshc";
    home = "/Users/santhoshc";
  };

  # Home Manager integration
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = { inherit inputs; };
    users.santhoshc = import ../../users/santhosh/work-mac-home.nix;
  };

  # Enable Touch ID authentication for sudo
  security.pam.services.sudo_local.touchIdAuth = true;

  system.stateVersion = 6;
}
