{
  description = "vladidobro system configuration";

  inputs.agenix.url = "github:ryantm/agenix";

  outputs = { self, nixpkgs, home-manager, agenix }:
  let
    lib = nixpkgs.lib;
    mylib = self.mylib;
  in 
  {
    mylib = import ./lib;

    overlays = {
      nushell = import overlays/nushell.nix;
    };

    nixosModules = {
      wirelessNetworks = import ./modules/wireless-networks.nix;
    };

    homeManagerConfigurations.vladidobro = {};

    nixosConfigurations.parok = lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
	./hardware/parok.nix
	home-manager.nixosModules.default
	agenix.nixosModules.default
        ./nixos/parok.nix
        self.nixosModules.wirelessNetworks
	(mylib.mkOverlaysModule [ self.overlays.nushell ])
      ];
    };
  };
}
