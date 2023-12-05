{ ... }:

{
  home.shellAliases = {
    g = "git";
  };
  
  programs.ssh = {
    enable = true;
  };

  programs.bash = {
    enable = true;
  };

  programs.tmux = {
    enable = true;
  };

  programs.neovim = {
    enable = true;
  };

  programs.git = {
    enable = true;
    aliases = {
      a = "add";
      aa = "add --all";

      c = "commit";
      ca = "commit --amend";

      co = "checkout";

      b = "branch";
      ba = "branch --all";

      d = "diff";
      dc = "diff --cached";
      ds = "diff --compact-summary";
      dcs = "diff --cached --compact-summary";

      l = "pull";

      p = "push";
    };
  };
}
