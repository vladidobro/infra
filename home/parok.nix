{ flake, config, pkgs, ... }:

{
  imports = [
    ./modules/minimal.nix
    ./modules/home.nix
    ./modules/graphical.nix
    ./modules/develop.nix
    ./modules/x11.nix
  ];

  home.username = "vladidobro";
  home.homeDirectory = "/home/vladidobro";

  home.stateVersion = "23.11";

  programs.git = {
    userName = "Vladislav Wohlrath";
    userEmail = flake.inputs.secrets.mail.main;
  };
}
