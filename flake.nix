{
description = "Santhosh's Nix System flake";

inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    nixos-hardware.url = "github:nixos/nixos-hardware/master";
  };

  outputs = { self, nixpkgs, nixos-hardware, ... } @inputs: {
      nixosConfigurations.thinkpad = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; };
          modules = [
          ./configuration.nix

          # hardware specific modules
          # lenovo-thinkpad-e14-intel gen 7 modules not available as of now.
          # nixos-hardware.nixosModules.lenovo-thinkpad-e14-intel
          # nixos-hardware.nixosModules.common-cpu-intel-cpu-optimizations
          nixos-hardware.nixosModules.common-cpu-intel
          nixos-hardware.nixosModules.common-gpu-intel
          nixos-hardware.nixosModules.common-pc-laptop-ssd
# enable flakes within itself;
          {
              nix.settings.experimental-features = ["nix-command" "flakes"];
            }
          ];
        };
    };
}
