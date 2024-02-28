{ flake, pkgs, ... }:

{
  programs.alacritty = {
    enable = true;
    settings = {
      env.TERM = "xterm-256color";
      font = {
        size = 16;
        normal = {
          family = "NotoMono Nerd Font Mono";
          style = "Regular";
        };
      };
      colors = {
        primary = {
          background = "0x282828";
          foreground = "0xd4be98";
        };
        normal = {
          black =   "0x3c3836";
          red =     "0xea6962";
          green =   "0xa9b665";
          yellow =  "0xd8a657";
          blue =    "0x7daea3";
          magenta = "0xd3869b";
          cyan =    "0x89b482";
          white =   "0xd4be98";
        };
        bright = {
          black =   "0x3c3836";
          red =     "0xea6962";
          green =   "0xa9b665";
          yellow =  "0xd8a657";
          blue =    "0x7daea3";
          magenta = "0xd3869b";
          cyan =    "0x89b482";
          white =   "0xd4be98";
        };
      };
      window = {
        option_as_alt = "OnlyLeft";
      };
    };
  };
}
