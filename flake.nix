{
  description = "vladidobro system configuration";

  inputs.agenix.url = "github:ryantm/agenix";

  outputs = { self, nixpkgs, home-manager, agenix }:
  let
    lib = nixpkgs.lib;
  in 
  rec {
    nixosModules = {
      wirelessNetworks = import ./modules/wireless-networks.nix;
    };

    nixosConfigurations.parok = lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
	./hardware/parok.nix
        ./nixos/parok.nix
        nixosModules.wirelessNetworks
	agenix.nixosModules.default
	home-manager.nixosModules.default
      ];
    };
  };
}
