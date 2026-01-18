{
  description = "vladidobro system configuration";

  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    deploy-rs.url = "github:serokell/deploy-rs";


    secrets.url = "git+ssh://git@github.com/vladidobro/secrets.git";
    svatba.url = "github:jaroslavpesek/wedding-app?tag=0.5.0";
    svatba.inputs.nixpkgs.follows = "nixpkgs-2405";

    # 24.05 - kulich, parok
    nixpkgs-2405.url = "github:NixOS/nixpkgs/nixos-24.05";
    home-manager-2405.url = "github:nix-community/home-manager/release-24.05";
    home-manager-2405.inputs.nixpkgs.follows = "nixpkgs-2405";
    nixos-mailserver-2405.url = "gitlab:simple-nixos-mailserver/nixos-mailserver/nixos-24.05";
    nixos-mailserver-2405.inputs.nixpkgs.follows = "nixpkgs-2405";

    # 24.11 - myskus
    nixpkgs-2411.url = "github:NixOS/nixpkgs/nixos-24.11";
    home-manager-2411.url = "github:nix-community/home-manager/release-24.11";
    home-manager-2411.inputs.nixpkgs.follows = "nixpkgs-2411";
    nixvim-2411.url = "github:nix-community/nixvim/nixos-24.11";
    nixvim-2411.inputs.nixpkgs.follows = "nixpkgs-2411";
    nixvim-2411.inputs.home-manager.follows = "home-manager-2411";
    nix-index-database-2411.url = "github:nix-community/nix-index-database";
    nix-index-database-2411.inputs.nixpkgs.follows = "nixpkgs-2411";
    agenix-2411.url = "github:ryantm/agenix";
    agenix-2411.inputs.nixpkgs.follows = "nixpkgs-2411";

    # 25.05 - sf
    nixpkgs-2505.url = "github:NixOS/nixpkgs/nixos-25.05";
    nix-darwin-2505.url = "github:LnL7/nix-darwin/nix-darwin-25.05";
    nix-darwin-2505.inputs.nixpkgs.follows = "nixpkgs-2505";
    home-manager-2505.url = "github:nix-community/home-manager/release-25.05";
    home-manager-2505.inputs.nixpkgs.follows = "nixpkgs-2505";
    nixvim-2505.url = "github:nix-community/nixvim/nixos-25.05";
    nixvim-2505.inputs.nixpkgs.follows = "nixpkgs-2505";
    nix-index-database-2505.url = "github:nix-community/nix-index-database";
    nix-index-database-2505.inputs.nixpkgs.follows = "nixpkgs-2505";

    # 25.11
    nixpkgs-2511.url = "github:NixOS/nixpkgs/nixos-25.11";
    nix-darwin-2511.url = "github:LnL7/nix-darwin/nix-darwin-25.11";
    nix-darwin-2511.inputs.nixpkgs.follows = "nixpkgs-2511";
    home-manager-2511.url = "github:nix-community/home-manager/release-25.11";
    home-manager-2511.inputs.nixpkgs.follows = "nixpkgs-2511";
    nixos-mailserver-2511.url = "gitlab:simple-nixos-mailserver/nixos-mailserver/nixos-25.11";
    nixos-mailserver-2511.inputs.nixpkgs.follows = "nixpkgs-2511";

    # unstable
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  };

  outputs = inputs@{ flake-parts, ... }: 
  flake-parts.lib.mkFlake { inherit inputs; } (top:
  {
    systems = [ "x86_64-linux" "aarch64-darwin" ];
    imports = [
      ./lib/deploy.nix
      ./lib/home.nix
      ./lib/vim.nix
      ./lib/vpsfree.nix
      ./hosts/kulich.nix
      ./hosts/myskus.nix
      ./hosts/parok.nix
      ./hosts/sf.nix
    ];
  });
}
