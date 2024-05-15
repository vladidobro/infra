{
  description = "vladidobro system configuration";

  inputs = {
    secrets = {
      type = "git";
      url = "ssh://git@github.com/vladidobro/secrets.git";
    };
    homepage = {
      type = "github";
      owner = "vladidobro";
      repo = "homepage";
      inputs.nixpkgs.follows = "nixpkgs";
    };
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
    neovim = {
      type = "github";
      owner = "nix-community";
      repo = "nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home";
      inputs.nix-darwin.follows = "darwin";
    };
    flake-utils = {
      type = "github";
      owner = "numtide";
      repo = "flake-utils";
    };
  };

  outputs = inputs@{ self, nixpkgs, flake-utils, treefmt, ... }:
  {
    inherit inputs;

    lib = import ./lib inputs;

    templates = {
      sf-py-stable = {
        path = ./templates/sf-py-stable;
        description = "sf python";
      };
      python = {
        path = ./templates/python;
        description = "python";
      };
      rust = {
        path = ./templates/rust;
        description = "rust";
      };
      haskell = {
        path = ./templates/haskell;
        description = "haskell";
      };
    };

    hmModules = {
      parok = import ./home/parok.nix;
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
      modules = [ ./hosts/parok.nix ];
    };

    nixosConfigurations.parok-wsl = self.lib.mkNixos {
      system = "x86_64-linux";
      modules = [ ./hosts/parok-wsl.nix ];
    };

    nixosConfigurations.kulich = self.lib.mkNixos {
      system = "x86_64-linux";
      modules = [ ./hosts/kulich.nix ];
    };

    darwinConfigurations.darwin = self.lib.mkDarwin {
      system = "aarch64-darwin";
      modules = [ ./hosts/darwin.nix ];
    };

    nixOnDroidConfigurations.lampin = self.lib.mkDroid {
      system = "aarch64-linux";
      modules = [ ./hosts/lampin.nix ];
    };
  } // flake-utils.lib.eachDefaultSystem (system: 
  let 
    pkgs = nixpkgs.legacyPackages."${system}";
    treefmtEval = treefmt.lib.evalModule pkgs ./treefmt.nix;
  in {
    devShells.default = pkgs.mkShell {
      packages = with pkgs; [ hello ];
    };
    formatter = treefmtEval.config.build.wrapper;
    checks.formatting = treefmtEval.config.build.check self;
  });
}
