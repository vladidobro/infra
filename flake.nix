{
  description = "vladidobro system configuration";

  inputs.agenix.url = "github:ryantm/agenix";

  outputs = { self, nixpkgs, home-manager, agenix }:
  {
    secrets = ./secrets;
    lib = import ./lib { flake = self; inherit nixpkgs; };

    overlays = {
      nushell = import overlays/nushell.nix;
    };

    nixosModules = {
      wirelessNetworks = import ./modules/wireless-networks.nix;
    };

    homeManagerConfigurations.vladidobro = {};

    nixosConfigurations.parok = self.lib.mkNixosSystem {
      system = "x86_64-linux";
      modules = [
	./hardware/parok.nix
	home-manager.nixosModules.default
	agenix.nixosModules.default
        ./nixos/parok.nix
        self.nixosModules.wirelessNetworks
	(self.lib.mkOverlaysModule [ self.overlays.nushell ])
	(self.lib.mkUserModule { name = "vladidobro"; home-config = import home/vladidobro; })
      ];
    };
  };
}
