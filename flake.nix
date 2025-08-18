{
  description = "vladidobro system configuration";

  inputs = {
    secrets = {
      url = "git+ssh://git@github.com/vladidobro/secrets.git";
    };
    svatba = {
      url = "github:jaroslavpesek/wedding-app?tag=0.5.0";
      inputs.nixpkgs.follows = "nixpkgs-2405";
    };
    svatba-dashboard = {
      url = "github:Danielwohlr/wedding_dashboard/nix";
      # no follows, needs up-to-date uv
      #inputs.nixpkgs.follows = "nixpkgs-2405";
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
    nixpkgs-2505 = {
      url = "github:NixOS/nixpkgs/nixos-25.05";
    };
    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    };
    nix-darwin-2505 = {
      url = "github:LnL7/nix-darwin/nix-darwin-25.05";
      inputs.nixpkgs.follows = "nixpkgs-2505";
    };
    home-manager-2405 = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs-2405";
    };
    home-manager-2411 = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs-2411";
    };
    home-manager-2505 = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs-2505";
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
    nix-index-database-2505 = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs-2505";
    };
    nixvim-2411 = {
      url = "github:nix-community/nixvim/nixos-24.11";
      inputs.nixpkgs.follows = "nixpkgs-2411";
      inputs.home-manager.follows = "home-manager-2411";
    };
    nixvim-2505 = {
      url = "github:nix-community/nixvim/nixos-25.05";
      inputs.nixpkgs.follows = "nixpkgs-2505";
    };
    deploy-rs = {
      url = "github:serokell/deploy-rs";
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
      ./lib/deploy.nix
      ./lib/home.nix
      ./lib/vim.nix
      ./hosts/kulich.nix
      ./hosts/myskus.nix
      ./hosts/parok.nix
      ./hosts/sf.nix
    ];
  });
}
