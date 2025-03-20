{
  description = "vladidobro system configuration";

  inputs = {
    secrets = {
      url = "git+ssh://git@github.com/vladidobro/secrets.git";
    };
    homepage = {
      url = "github:vladidobro/homepage";
      inputs.nixpkgs.follows = "nixpkgs-2405";
    };
    svatba = {
      url = "github:jaroslavpesek/wedding-app?tag=0.4.3";
      inputs.nixpkgs.follows = "nixpkgs-2405";
    };
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
    };
    nixpkgs-2405 = {
      url = "github:NixOS/nixpkgs/nixos-24.05";
    };
    nixpkgs-2411 = {
      url = "github:NixOS/nixpkgs/nixos-24.11";
    };
    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    };
    nix-darwin-2411 = {
      url = "github:LnL7/nix-darwin/nix-darwin-24.11";
      inputs.nixpkgs.follows = "nixpkgs-2411";
    };
    home-manager-2405 = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs-2405";
    };
    home-manager-2411 = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs-2411";
    };
    agenix-2405 = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs-2405";
    };
    agenix-2411 = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs-2411";
    };
    nixos-mailserver-2405 = {
      url = "gitlab:simple-nixos-mailserver/nixos-mailserver/nixos-24.05";
      inputs.nixpkgs.follows = "nixpkgs-2405";
    };
    nix-index-database-2405 = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs-2405";
    };
    nix-index-database-2411 = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs-2411";
    };
    nixvim-2411 = {
      url = "github:nix-community/nixvim/nixos-24.11";
      inputs.nixpkgs.follows = "nixpkgs-2411";
      inputs.home-manager.follows = "home-manager-2411";
      inputs.nix-darwin.follows = "nix-darwin-2411";
    };
  };

  outputs = inputs@{ 
    flake-parts, 
    ... 
  }: 
  flake-parts.lib.mkFlake { inherit inputs; } (top:
  {
    systems = [ "x86_64-linux" "aarch64-darwin" ];
    imports = [
      ./hosts
      ./home
    ];
  });
}
