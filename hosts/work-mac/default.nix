{ pkgs, inputs, ... }: {
  imports = [
    #../../modules/packages/cli.nix # Reuse existing CLI tools
    inputs.home-manager.darwinModules.home-manager
  ];

  # System options for nix-darwin
  # services.nix-daemon.enable = true;
  nix.enable = true;
  programs.zsh.enable = true;

  # Target platform (Use "x86_64-darwin" if using an Intel Mac)
  nixpkgs.hostPlatform = "aarch64-darwin";

  # Allow unfree software if needed
  nixpkgs.config.allowUnfree = true;

users.users.santhosh = {
    name = "santhoshc";
    home = "/Users/santhoshc";
  };

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = { inherit inputs; };
    users.santhosh = import ../../users/santhosh/work-mac-home.nix;
  };

security.pam.services.sudo_local.touchIdAuth = true;
  system.stateVersion = 6;
}
