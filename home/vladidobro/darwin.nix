{ flake, config, pkgs, ... }:

{
  imports = [
    ./modules/minimal.nix
    ./modules/home.nix
  ];

  home.username = "vladislavwohlrath";
  home.homeDirectory = "/Users/vladislavwohlrath";

  home.stateVersion = "23.11";
  home.packages = with pkgs; [
  ];
}
