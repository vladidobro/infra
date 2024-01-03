{ config, pkgs, ... }:

{
  imports = [
    ./modules/minimal.nix
    ./modules/home.nix
    ./modules/gui.nix
    ./modules/develop.nix
  ];

  home.username = "vladidobro";
  home.homeDirectory = "/home/vladidobro";

  home.stateVersion = "23.11";

  home.packages = with pkgs; [
    transmission-qt
  ];

  programs.git = {
    userName = "Vladislav Wohlrath";
    userEmail = "vladislav@wohlrath.cz";
  };

  home.shellAliases = {
    rebuild = "sudo nixos-rebuild switch --flake /home/vladidobro/configuration.nix#parok";
  };
}
