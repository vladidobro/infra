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
    mailserver = {
      type = "gitlab";
      owner = "simple-nixos-mailserver";
      repo = "nixos-mailserver";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, darwin, wsl, droid, home, agenix, mailserver }@inputs:
  {
    secrets = import ./secrets;
    lib = import ./lib inputs;

    homeManagerConfigurations.vladidobro = self.lib.mkHomeManagerConfiguration {
      name = "vladidobro";
      modules = [
        ./home/vladidobro
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
      	  home = ./home/vladidobro;
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
      system = "aarch64-darwin";
      modules = [
        ./hosts/mac.nix
        home-manager.darwinModules.home-manager
        {
        home-manager.useUserPackages = true;
        home-manager.useGlobalPkgs = true;
        users.users.vladislavwohlrath.home = "/Users/vladislavwohlrath";
        home-manager.users.vladislavwohlrath = import ./home/vladidobro/darwin.nix;
        }
      ];
    };

    nixOnDroidConfigurations.lampin = self.lib.mkNixOnDroidConfiguration {
      modules = [
        ./hosts/lampin.nix
      ];
    };
  };
}
