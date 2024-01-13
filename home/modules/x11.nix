{ pkgs, ... }:

{
  home.packages = with pkgs; [
    nerdfonts
    poppler_utils
  ];

  fonts.fontconfig.enable = true;
}
