{ flake, config, pkgs, ... }:

{
  imports = [
    ./modules/minimal.nix
    ./modules/home.nix
    #./modules/develop.nix
    ./modules/x11.nix
    ./modules/nvim
  ];

  home = {
    username = "vladidobro";
    homeDirectory = "/home/vladidobro";
  };

  home.stateVersion = "23.11";

  programs.git = {
    userName = "Vladislav Wohlrath";
    userEmail = flake.inputs.secrets.mail.main;
  };

  home.shellAliases = {
    e = "nvim";
    rebuild = "sudo nixos-rebuild switch --flake $NIXOS_HOME";
  };

  home.sessionVariables = {
    NIXOS_HOME = "/etc/nixos";
  };

  programs.alacritty = {
    enable = true;
    settings = {
      #env.TERM = "xterm-256color";
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
    };
  };
}
