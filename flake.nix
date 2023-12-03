{
  description = "vladidobro system configuration";

  inputs = {
    nixpkgs = {
      type = "indirect";
      id = "nixpkgs";
    };
    nix-darwin = {
      type = "indirect";
      id = "nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      type = "indirect";
      id = "home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    agenix = {
      type = "github";
      owner = "ryantm";
      repo = "agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nix-darwin, home-manager, agenix }@inputs:
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
