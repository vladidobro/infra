{ config, pkgs, ... }:

{
  home.username = "vladidobro";
  home.homeDirectory = "/home/vladidobro";

  home.stateVersion = "23.11";

  home.packages = with pkgs; [
    ripgrep
  ];

  programs.git = {
    enable = true;
    userName = "Vladislav Wohlrath";
    userEmail = "vladislav@wohlrath.cz";
  };

  programs.ssh = {
    enable = true;
  };
}
