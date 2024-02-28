{ flake, config, pkgs, ... }:

{
  imports = [
    ./modules/nvim
  ];
  home.stateVersion = "23.11";

  home.username = "vladidobro";
  home.homeDirectory = "/home/vladidobro";
}
