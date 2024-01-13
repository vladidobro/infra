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

      b = "branch";
      ba = "branch --all";
      bd = "branch --delete";
      bdd = "branch --delete --force";
      bu = "branch --set-upstream-to";
      bm = "branch -m";

      c = "commit --verbose";
      ca = "commit --amend --verbose";

      co = "checkout";
      cb = "checkout -b";

      d = "diff";
      dc = "diff --cached";
      ds = "diff --compact-summary";
      dcs = "diff --cached --compact-summary";

      f = "fetch";
      fa = "fetch --all";

      l = "pull";

      lg = "log --oneline --decorate --graph";
      lga = "log --oneline --decorate --graph --all";

      m = "merge";
      ma = "merge --abort";

      p = "push";
      pt = "push --tags";
      pa = "push --all";
      pu = "push --set-upstream";

      s = "status";
      ss = "status --short";

      st = "stash push";
      sta = "stash apply";
      stp = "stash pop";
      stc = "stash clear";
      std = "stash drop";
      stl = "stash list";
      sts = "stash show";

      t = "tag";
      ta = "tag --annotate";

      alias = "! git config --get-regexp ^alias\\. | sed -e s/^alias\\.// -e s/\\ /\\ =\\ /";
    };
  };
}
