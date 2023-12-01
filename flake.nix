{
  description = "vladidobro system configuration";

  inputs.agenix.url = "github:ryantm/agenix";

  outputs = { self, nixpkgs, home-manager, agenix }:
  let
    lib = nixpkgs.lib;
    mylib = self.mylib;
    mkNixosSystem = mylib.mkNixosSystem;
  in 
  {
    secrets = ./secrets;
    mylib = import ./lib { inherit self nixpkgs; };

    overlays = {
      nushell = import overlays/nushell.nix;
    };

    nixosModules = {
      wirelessNetworks = import ./modules/wireless-networks.nix;
    };

    homeManagerConfigurations.vladidobro = {};

    nixosConfigurations.parok = mkNixosSystem {
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
