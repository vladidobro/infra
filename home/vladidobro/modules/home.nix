{ ... }:

{
  programs.zsh = {
    enable = true;
  };

  programs.nushell = {
    enable = true;
  };

  programs.lf = {
    enable = true;
  };

  programs.helix = {
    enable = true;
    defaultEditor = true;
    settings = {
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

  programs.atuin = {
    enable = true;
  };
}
