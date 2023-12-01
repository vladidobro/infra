{
  description = "vladidobro system configuration";

  inputs.agenix.url = "github:ryantm/agenix";

  outputs = { self, nixpkgs, home-manager, agenix }@inputs:
  {
    secrets = import ./secrets;
    lib = import ./lib inputs;

    overlays = {
      nushell = import ./overlays/nushell.nix;
    };

    nixosModules = {
      wirelessNetworks = import ./modules/wireless-networks.nix;
      agenix = import ./modules/agenix.nix;
      homeManager = import ./modules/home-manager.nix;
    };

    homeManagerModules.vladidobro = import ./home/vladidobro;

    homeManagerConfigurations.vladidobro = self.lib.mkHomeManagerConfiguration {
      name = "vladidobro";
      modules = [
        self.homeManagerModules.vladidobro
      ];
    };

    nixosConfigurations.parok = self.lib.mkNixosSystem {
      system = "x86_64-linux";
      modules = [
	./hardware/parok.nix
        ./nixos/parok.nix
	(self.lib.mkUserModule {
	  name = "vladidobro"; 
	  home = self.homeManagerModules.vladidobro;
	})
      ];
    };
  };
}
