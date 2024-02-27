{ flake, config, pkgs, ... }:

{
  imports = [
    flake.inputs.neovim.homeManagerModules.nixvim
  ];

  home.stateVersion = "23.11";

  home.username = "vladidobro";
  home.homeDirectory = "/home/vladidobro";
}
