{ inputs, ... }:
{
  imports = [
    ./configuration.nix
    ../../modules/packages/cli.nix
    ../../modules/packages/desktop.nix
    inputs.nix-index-database.nixosModules.default
    inputs.nixos-hardware.nixosModules.common-cpu-intel
    inputs.nixos-hardware.nixosModules.common-gpu-intel
    inputs.nixos-hardware.nixosModules.common-pc-laptop-ssd
    inputs.home-manager.nixosModules.home-manager
  ];

  programs.nix-index-database.comma.enable = true;

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;

    extraSpecialArgs = {
      inherit inputs;
    };
    users.santhosh = import ../../users/santhosh/home.nix;
    users.lisasri = import ../../users/lisasri/home.nix;
  };
}
