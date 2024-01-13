{ pkgs, ... }:

{
  home.packages = with pkgs; [
    dmenu-rs
    brave
  ];

  programs.alacritty = {
    enable = true;
  };
}
