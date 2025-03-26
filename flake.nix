{
  description = "weddind dashboard streamlit app";

  inputs = {
    nixpkgs = {
      url = "github:NixOS/nixpkgs";
    };
    pyproject-nix = {
      url = "github:pyproject-nix/pyproject.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    uv2nix = {
      url = "github:pyproject-nix/uv2nix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.pyproject-nix.follows = "pyproject-nix";
    };
    uv2nix_hammer_overrides = {
      url = "github:TyberiusPrime/uv2nix_hammer_overrides";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.pyproject-nix.follows = "pyproject-nix";
    };
    pyproject-build-systems = {
      url = "github:pyproject-nix/build-system-pkgs";
      inputs.uv2nix.follows = "uv2nix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.pyproject-nix.follows = "pyproject-nix";
    };
  };

  outputs =
  {
    self,
    nixpkgs,
    uv2nix,
    uv2nix_hammer_overrides,
    pyproject-build-systems,
    ...
  }:
      let
      system = "x86_64-linux";
      inherit (uv2nix.inputs) pyproject-nix;
      workspace = uv2nix.lib.workspace.loadWorkspace { workspaceRoot = ./.; };

      pkgs = import nixpkgs {
        system = system;
        config.allowUnfree = true;
      };

      defaultPackage =
        let
          overlay = workspace.mkPyprojectOverlay { sourcePreference = "wheel"; };
          pyprojectOverrides = pkgs.lib.composeManyExtensions [
            (uv2nix_hammer_overrides.overrides pkgs) 
            ( _final: _prev: { })
            pyproject-build-systems.overlays.default
          ];
          interpreter = pkgs.python312;

          spec = workspace.deps.default;

          pythonSet' =
            (pkgs.callPackage pyproject-nix.build.packages { python = interpreter; }).overrideScope
              overlay;

          pythonSet = pythonSet'.pythonPkgsHostHost.overrideScope pyprojectOverrides;
        in
        pythonSet.mkVirtualEnv "vlada-dashboard" spec;
    in
    {
      packages."${system}".default = defaultPackage;
      devShells."${system}".default = pkgs.mkShell {
        packages = [
          pkgs.uv
          defaultPackage
        ];
      };
      devShells."${system}".uv = pkgs.mkShell { packages = [ nixpkgs.legacyPackages."${system}".uv ]; };
      nixosModules.default = { config, pkgs, lib, ... }: 
      with lib;
      let cfg = config.services.svatba.dashboard;
      in {
        options.services.svatba.dashboard = {
          enable = mkEnableOption "Svatebni dashboard";
          host = mkOption {
            type = types.str;
          };
          port = mkOption {
            type = types.port;
            default = 2025;
          };
          mongoUrl = mkOption {
            type = types.str;
          };
        };

        config = mkIf cfg.enable {
          systemd.services."${cfg.host}" = {
            wantedBy = [ "multi-user.target" ];
            serviceConfig = {
              ExecStart = "${self.packages.x86_64-linux.default}/bin/vlada-dashboard ${cfg.mongoUrl}";
            };
          };
        };
      };
    };
}
