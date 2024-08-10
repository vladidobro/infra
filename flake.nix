{
  description = "vladidobro system configuration";

  inputs = {
    secrets = {
      url = "git+ssh://git@github.com/vladidobro/secrets.git";
    };
    homepage = {
      url = "github:vladidobro/homepage";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixos-24.05";
    };
    nixpkgs-unstable = {
      url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    };
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    NixOS-WSL = {
      url = "github:nix-community/NixOS-WSL";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-on-droid = {
      url = "github:nix-community/nix-on-droid";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-mailserver = {
      url = "gitlab:simple-nixos-mailserver/nixos-mailserver";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs-python = {
      url = "github:cachix/nixpkgs-python";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
      inputs.nix-darwin.follows = "nix-darwin";
    };
    flake-utils = {
      url = "github:numtide/flake-utils";
    };
  };

  outputs = inputs@{ 
    self,
    secrets,
    nixpkgs,
    flake-utils,
    nix-darwin,
    treefmt-nix,
    nix-on-droid,
    home-manager,
    agenix,
    nixos-mailserver,
    nix-index-database,
    nixvim,
    ... 
  }: {

    nixosConfigurations.parok = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [ 
        ./hosts/parok.nix 
        ./hardware/parok.nix
        home-manager.nixosModules.home-manager
        agenix.nixosModules.default
      ];
    };

    nixosConfigurations.parok-wsl = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [ 
        ./hosts/parok-wsl.nix 
        ./hardware/wsl.nix
      ];
    };

    nixosConfigurations.kulich = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [ 
        ./hosts/kulich.nix 
        ./hardware/vpsfree.nix
        secrets.kulich
        home-manager.nixosModules.home-manager
        agenix.nixosModules.default
        nixos-mailserver.nixosModules.default
        # homepage.nixosModules.default
      ];
    };

    nixosConfigurations.kublajchan = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./hosts/kublajchan.nix
        ./hardware/kublajchan.nix
        home-manager.nixosModules.home-manager
      ];
    };

    darwinConfigurations.sf = nix-darwin.lib.darwinSystem {
      system = "aarch64-darwin";
      modules = [
        ./hosts/sf.nix 
        secrets.sf
        home-manager.darwinModules.home-manager
        { home-manager.sharedModules = [ 
          nix-index-database.hmModules.nix-index 
          nixvim.homeManagerModules.nixvim
        ]; }
      ];
    };

    nixOnDroidConfigurations.lampin = nix-on-droid.lib.nixOnDroidConfiguration {
      pkgs = nixpkgs.legacyPackages.aarch64-linux;
      modules = [ 
        ./hosts/lampin.nix 
      ];
    };

    homeManagerModules.default = ./home;

    templates = {
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

  } // flake-utils.lib.eachDefaultSystem (system: 
  let 
    pkgs = nixpkgs.legacyPackages."${system}";
    treefmtEval = treefmt-nix.lib.evalModule pkgs ./treefmt.nix;
  in {
    formatter = treefmtEval.config.build.wrapper;
    checks.formatting = treefmtEval.config.build.check self;

    devShells.default = pkgs.mkShell {
      packages = with pkgs; [ hello ];
    };

  });
}
