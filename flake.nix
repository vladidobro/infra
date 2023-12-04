{
  description = "vladidobro system configuration";

  inputs = {
    nixpkgs = {
      type = "indirect";
      id = "nixpkgs";
    };
    darwin = {
      type = "indirect";
      id = "nix-darwin";
    };
    wsl = {
      type = "github";
      owner = "nix-community";
      repo = "NixOS-WSL";
    };
    droid = {
      type = "github";
      owner = "nix-community";
      repo = "nix-on-droid";
    };
    home = {
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

  outputs = { self, nixpkgs, darwin, wsl, droid, home, agenix }@inputs:
  {
    secrets = import ./secrets;
    lib = import ./lib inputs;

    overlays = {
      nushell = import ./overlays/nushell.nix;
    };

    homeManagerModules.vladidobro = import ./home/vladidobro;

    homeManagerConfigurations.vladidobro = self.lib.mkHomeManagerConfiguration {
      name = "vladidobro";
      modules = [
        self.homeManagerModules.vladidobro
      ];
    };

    nixosModules = {
      wirelessNetworks = import ./modules/wireless-networks.nix;
      agenix = import ./modules/agenix.nix;
      homeManager = import ./modules/home-manager.nix;
      wslBase = import ./modules/wsl-base.nix;
    };

    nixosConfigurations.parok = self.lib.mkNixosSystem {
      system = "x86_64-linux";
      modules = [
	./hardware/parok.nix
        ./hosts/parok.nix
	(self.lib.mkUserModule {
	  name = "vladidobro"; 
	  home = self.homeManagerModules.vladidobro;
	})
      ];
    };

    nixosConfigurations.parok-wsl = self.lib.mkNixosSystem {
      system = "x86_64-linux";
      modules = [
        self.nixosModules.wslBase
        ./hosts/parok-wsl.nix
      ];
    };

    nixosConfigurations.kulich = self.lib.mkNixosSystem {
      system = "x86_64-linux";
      modules = [
        ./hosts/kulich.nix
      ];
    };

    darwinConfigurations.mac = self.lib.mkDarwinSystem {
      modules = [
        ./hosts/mac.nix
      ];
    };

    nixOnDroidConfigurations.lampin = self.lib.mkNixOnDroidConfiguration {
      modules = [
        ./hosts/lampin.nix
      ];
    };
  };
}
