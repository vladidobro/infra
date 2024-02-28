{ pkgs, ... }:

{
  home.packages = with pkgs; [
    nerdfonts
    poppler_utils
    dmenu-rs
    brave
  ];

  fonts.fontconfig.enable = true;
  programs.alacritty = {
    enable = true;
  };
}
