{
description = "Santhosh's Nix System flake";

inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
        url = "github:nix-community/home-manager";
        inputs.nixpkgs.follows = "nixpkgs";
      };

    nixos-hardware.url = "github:nixos/nixos-hardware/master";
  };

  outputs = { self, nixpkgs, home-manager, nixos-hardware, ... } @inputs: {
      nixosConfigurations.thinkpad = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; };
          modules = [
          ./hosts/thinkpad/configuration.nix
          ./modules/packages/cli.nix
          ./modules/packages/desktop.nix

          # hardware specific modules
          # lenovo-thinkpad-e14-intel gen 7 modules not available as of now.
          # nixos-hardware.nixosModules.lenovo-thinkpad-e14-intel
          # nixos-hardware.nixosModules.common-cpu-intel-cpu-optimizations
          nixos-hardware.nixosModules.common-cpu-intel
          nixos-hardware.nixosModules.common-gpu-intel
          nixos-hardware.nixosModules.common-pc-laptop-ssd
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.santhosh = import ./users/santhosh/home.nix;
          }
          ];
        };
    };
}
