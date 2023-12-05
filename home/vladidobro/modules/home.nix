{ pkgs, ... }:

{
  home.packages = with pkgs; [
    nerdfonts
    poppler_utils
    unzip
    unrar-wrapper
    p7zip
    highlight
  ];

  fonts.fontconfig.enable = true;

  # Shells

  programs.zsh = {
    enable = true;
  };

  programs.nushell = {
    enable = true;
  };

  # Editor

  programs.helix = {
    enable = true;
    defaultEditor = true;
    settings = {
      theme = "gruvbox";
      editor = {
        line-number = "relative";
        lsp.display-messages = true;
      };
      keys.normal = {
        Z = { 
          Z = ":x";
          Q = ":q!";
        };
      };
    };
  };

  # Shell integration

  programs.lf = {  # file manager
    enable = true;
    previewer.source = pkgs.writeShellScript "pv.sh" ''
      #!/bin/sh

      case "$1" in 
        *.tar*) tar tf "$1";;
        *.zip) unzip -l "$1";;
        *.rar) unrar l "$1";;
        *.7z) 7z l "$1";;
        *.pdf) pdftotext "$1" -;;
        *) highlight -O ansi "$1" || cat "$1";;
      esac
    '';
  };

  programs.zoxide = {  # smart cd
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    enableNushellIntegration = false;  # TODO
  };

  programs.atuin = {  # history
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    enableNushellIntegration = true;
  };

  programs.starship = {  # prompt
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    enableNushellIntegration = true;
    settings = {
      character = {
        success_symbol = "[λ](green)";
        error_symbol = "[λ](red)";
      };
    };
  };

  programs.git.delta.enable = true;
}
