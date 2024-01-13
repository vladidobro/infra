{
  description = "vladidobro system configuration";

  inputs = {
    nixpkgs = {
      type = "indirect";
      id = "nixpkgs";
    };
    darwin = {
      type = "github";
      owner = "LnL7";
      repo = "nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    wsl = {
      type = "github";
      owner = "nix-community";
      repo = "NixOS-WSL";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    droid = {
      type = "github";
      owner = "nix-community";
      repo = "nix-on-droid";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home = {
      type = "github";
      owner = "nix-community";
      repo = "home-manager";
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
    index = {
      type = "github";
      owner = "nix-community";
      repo = "nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nixpkgs, darwin, wsl, droid, home, agenix, mailserver, index }:
  {
    secrets = import ./secrets;
    lib = import ./lib inputs;

    hmModules = {};

    homeConfigurations = {};

    nixosModules = {
      wirelessNetworks = import ./modules/wireless-networks.nix;
      agenix = import ./modules/agenix.nix;
      homeManager = import ./modules/home-manager.nix;
      wslBase = import ./modules/wsl-base.nix;
    };

    nixosConfigurations.parok = self.lib.mkNixos {
      system = "x86_64-linux";
      modules = [
        ./hosts/parok.nix
      ];
    };

    nixosConfigurations.parok-wsl = self.lib.mkNixos {
      system = "x86_64-linux";
      modules = [
        ./hosts/parok-wsl.nix
      ];
    };

    nixosConfigurations.kulich = self.lib.mkNixos {
      system = "x86_64-linux";
      modules = [
        ./hosts/kulich.nix
      ];
    };

    darwinConfigurations.mac = self.lib.mkDarwin {
      system = "aarch64-darwin";
      modules = [
        ./hosts/mac.nix
      ];
    };

    nixOnDroidConfigurations.lampin = self.lib.mkDroid {
      system = "aarch64-linux";
      modules = [
        ./hosts/lampin.nix
      ];
    };
  };
}
