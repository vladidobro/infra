{
  description = "vladidobro system configuration";

  inputs = {
    nixpkgs = {
      type = "github";
      owner = "NixOS";
      repo = "nixpkgs";
      ref = "nixpkgs-unstable";
    };
    unstable = {
      type = "github";
      owner = "NixOS";
      repo = "nixpkgs";
      ref = "nixpkgs-unstable";
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
    treefmt = {
      type = "github";
      owner = "numtide";
      repo = "treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    python = {
      type = "github";
      owner = "cachix";
      repo = "nixpkgs-python";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nixpkgs, unstable, darwin, wsl, droid, home, agenix, mailserver, index, treefmt, python }:
  {
    inherit inputs;

    secrets = import ./secrets;
    lib = import ./lib inputs;

    templates = {
      poetry.path = ./templates/poetry;
    };

    hmModules = {
      kulich = import ./home/kulich.nix;
      darwin = import ./home/darwin.nix;
    };

    nixosModules = {
      wifi = import ./modules/wifi.nix;
      wsl = import ./modules/wsl.nix;
      vpsfree = import ./modules/vpsfree.nix;
    };
    
    nixosModules.hardware = {
      parok = import ./hardware/parok.nix;
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

    darwinConfigurations.darwin = self.lib.mkDarwin {
      system = "aarch64-darwin";
      modules = [
        ./hosts/darwin.nix
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
