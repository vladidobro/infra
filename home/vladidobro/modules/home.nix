{ pkgs, ... }:

{
  home.packages = with pkgs; [
    unzip
    unrar-wrapper
    p7zip
    highlight
  ];

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

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    enableNushellIntegration = false;
  };
    
  programs.lf = {
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

  programs.zoxide = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    enableNushellIntegration = false;  # TODO
  };

  programs.atuin = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    enableNushellIntegration = true;
  };

  programs.starship = {
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
