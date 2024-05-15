{
  description = "python app";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable-small";
    poetry2nix = {
      url = "github:nix-community/poetry2nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    treefmt = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    }
  };

  outputs = { self, nixpkgs, flake-utils, poetry2nix, treefmt }:
  flake-utils.lib.eachDefaultSystem (system:
  let
    pkgs = nixpkgs.legacyPackages.${system};
    inherit (poetry2nix.lib.mkPoetry2Nix { inherit pkgs; }) mkPoetryApplication;
    treefmtEval = treefmt.lib.evalModule pkgs ./treefmt.nix;
  in {
    packages = {
      myapp = mkPoetryApplication { projectDir = self; };
      default = self.packages.${system}.myapp;
    };

    devShells.default = pkgs.mkShell {
      inputsFrom = [ self.packages.${system}.myapp ];
    };

    devShells.poetry = pkgs.mkShell {
      packages = [ pkgs.poetry ];
    };

    formatter = treefmtEval.config.build.wrapper;
    checks.formatting = treefmtEval.config.build.check self;
  }) // {
    nixosModules.app = { config, pkgs, ... }:
    {
      packages = self.packages.${config.system}.myapp;
    };
  };
}
