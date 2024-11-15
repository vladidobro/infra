{ config, pkgs, lib, ... }:

with lib;
let 
  cfg = config.vladidobro;
  platform = pkgs.stdenv.hostPlatform;
in {
  imports = [
    ./modules/nvim.nix
    ./modules/duckdb.nix
    ./modules/ipython.nix
    ./modules/rebuild.nix
  ];


  options.vladidobro = {
    enable = mkEnableOption "vladidobro";
    aliases = mkEnableOption "aliases";
    minimal = mkEnableOption "minimal";
    basic = mkEnableOption "basic";
    full = mkEnableOption "full";
    graphical = mkEnableOption "graphical";
    develop = {
      enable = mkEnableOption "develop";
      c = mkEnableOption "c";
      python = mkEnableOption "python";
      rust = mkEnableOption "rust";
      haskell = mkEnableOption "haskell";
    };
    data = {
      duckdb = mkEnableOption "duckdb";
    };
  };

  config = mkIf cfg.enable {

    home.packages = with pkgs; ([
      unzip
      unrar-wrapper
      p7zip
      highlight
      ripgrep
      jq
      parallel
      jqp
      lftp
      sqlite
      unixtools.watch
      socat
    ]); 
    # TODO
    # + (mkIf (platform.isLinux && cfg.graphical) [
    #   nerdfonts
    #   poppler_utils
    #   dmenu-rs
    #   brave
    # ]));

    home.shellAliases = mkIf cfg.aliases {
      g = "git";
      e = "nvim";
    };
    
    programs.ssh = mkIf cfg.minimal {
      enable = mkDefault true;
    };

    programs.bash = mkIf cfg.minimal {
      enable = mkDefault true;
    };

    programs.neovim = mkIf cfg.basic {
      enable = mkDefault false;
    };

    programs.git = mkIf cfg.minimal {
      enable = mkDefault true;

      userName = mkDefault "Vladislav Wohlrath";

      extraConfig = mkIf cfg.basic {
        init.defaultBranch = mkDefault "main";
        pager.branch = mkDefault false;
        push.autoSetupRemote = mkDefault true;
        push.default = mkDefault "current";
      };

      delta.enable = mkIf cfg.full true;

      aliases = mkIf cfg.aliases {
        a = "add";
        aa = "add --all";
        ac = "! git add --all && git commit --verbose";

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

        ra = "remote add";
        rp = "remote prune";
        rpo = "remote prune origin";

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

    programs.tmux = mkIf cfg.basic {
      enable = true;
      baseIndex = 1;
      escapeTime = 0;
      disableConfirmationPrompt = true;
      customPaneNavigationAndResize = true;
      keyMode = "vi";
      mouse = true;
      prefix = "C-Space";
      shortcut = "Space";
      extraConfig = ''
          set -g default-terminal "xterm-256color"
          set -ag terminal-overrides ",xterm-256color:RGB"
          set -g detach-on-destroy off

          set -g set-clipboard ${if platform.isDarwin then "off" else "on"}
          set -g status-bg blue

          bind-key -T copy-mode-vi 'C-v' send -X rectangle-toggle
          bind-key -T copy-mode-vi v send -X begin-selection
          bind-key -T copy-mode-vi V send -X select-line
          ${if platform.isDarwin 
            then "bind-key -T copy-mode-vi y send -X copy-pipe-and-cancel 'pbcopy'"
            else "bind-key -T copy-mode-vi y send -X copy-selection"
          }

          is_vim="ps -o state= -o comm= -t '#{pane_tty}' \
              | grep -iqE '^[^TXZ ]+ +(\\S+\\/)?g?(view|n?vim?x?)(diff)?$'"

          bind-key -n 'M-h' if-shell "$is_vim" 'send-keys M-h' 'select-pane -L'
          bind-key -n 'M-j' if-shell "$is_vim" 'send-keys M-j' 'select-pane -D'
          bind-key -n 'M-k' if-shell "$is_vim" 'send-keys M-k' 'select-pane -U'
          bind-key -n 'M-l' if-shell "$is_vim" 'send-keys M-l' 'select-pane -R'

          tmux_version='$(tmux -V | sed -En "s/^tmux ([0-9]+(.[0-9]+)?).*/\1/p")'

          bind-key -n 'M-\' if-shell "$is_vim" 'send-keys M-\\' 'select-pane -l'

          bind-key -n 'M-Space' if-shell "$is_vim" 'send-keys M-Space' 'select-pane -t:.+'

          bind-key -T copy-mode-vi 'M-h' select-pane -L
          bind-key -T copy-mode-vi 'M-j' select-pane -D
          bind-key -T copy-mode-vi 'M-k' select-pane -U
          bind-key -T copy-mode-vi 'M-l' select-pane -R
          bind-key -T copy-mode-vi 'M-\' select-pane -l
          bind-key -T copy-mode-vi 'M-Space' select-pane -t:.+

          bind-key -n 'M-1' select-window -t 1
          bind-key -n 'M-2' select-window -t 2
          bind-key -n 'M-3' select-window -t 3
          bind-key -n 'M-4' select-window -t 4
          bind-key -n 'M-5' select-window -t 5
          bind-key -n 'M-6' select-window -t 6
          bind-key -n 'M-7' select-window -t 7
          bind-key -n 'M-8' select-window -t 8
          bind-key -n 'M-9' select-window -t 9
          bind-key -n 'M-0' select-window -t 10

          bind-key -r '+' resize-pane -U 10
          bind-key -r '-' resize-pane -D 10
          bind-key -r '<' resize-pane -L 20
          bind-key -r '>' resize-pane -R 20
      '';
    };

    programs.zsh = mkIf cfg.basic {
      enable = true;
      defaultKeymap = "viins";
      syntaxHighlighting.enable = true;
      shellAliases = mkIf cfg.aliases {
        _ = "sudo ";
        ls = "ls --color=auto";
        ll = "ls -lh";
        la = "ls -a";
        l = "ls -lah";
        f = "lfcd";
        py = "ipython";
        ".." = "cd ..";
      };
      initExtra = ''
        bindkey '^P' up-line-or-history
        bindkey '^N' down-line-or-history
        bindkey '^A' beginning-of-line
        bindkey '^E' end-of-line
        bindkey '^F' forward-word
        bindkey '^[[Z' reverse-menu-complete

        lfcd () {
            tmp="$(mktemp)"
            lf -last-dir-path="$tmp" "$@"
            if [ -f "$tmp" ]; then
                dir="$(cat "$tmp")"
                rm -f "$tmp"
                if [ -d "$dir" ]; then
                    if [ "$dir" != "$(pwd)" ]; then
                        cd "$dir"
                    fi
                fi
            fi
        }
      '';
    };

    programs.nushell = mkIf cfg.full {
      enable = true;
      configFile.text = ''
        let config = {
          show_banner: false
        }

        $env.config = ($env.config? | default {} | merge $config)

        def --env lfcd [] {
            let tmp = (mktemp)
            lf $"-last-dir-path=($tmp)"
            let cddir = if ($tmp | path exists) { open $tmp --raw } else { $env.PWD }
            cd $cddir
        }
      '';
    };
    programs.helix = mkIf cfg.full {
      enable = true;
      defaultEditor = false;
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

    programs.direnv = mkIf cfg.full {
      enable = true;
      nix-direnv.enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
      enableNushellIntegration = true;
      stdlib = ''
        layout_poetry() {
          PYPROJECT_TOML="''${PYPROJECT_TOML:-pyproject.toml}"
          if [[ ! -f "$PYPROJECT_TOML" ]]; then
              log_status "No pyproject.toml found. Executing \`poetry init\` to create a \`$PYPROJECT_TOML\` first."
              poetry init
          fi

          if [[ -d ".venv" ]]; then
              VIRTUAL_ENV="$(pwd)/.venv"
          else
              VIRTUAL_ENV=$(poetry env info --path 2>/dev/null ; true)
          fi

          if [[ -z $VIRTUAL_ENV || ! -d $VIRTUAL_ENV ]]; then
              log_status "No virtual environment exists. Executing \`poetry install\` to create one."
              poetry install
              VIRTUAL_ENV=$(poetry env info --path)
          fi

          PATH_add "$VIRTUAL_ENV/bin"
          export POETRY_ACTIVE=1
          export VIRTUAL_ENV
        }
      '';
    };
      
    programs.lf = mkIf cfg.full {
      enable = true;
      keybindings = {
        zp = "set preview!";
        x = "$$f";
        X = "!$f";
        "<c-x>" = "$chmod +x $fx; lf -remote \"send $id reload\"";
        "<enter>" = "shell";
        D = "delete";
        T = "trash";
        i = "$highlight --force -O ansi -i \"$f\" | $PAGER";
      };
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
      settings = {
        shellopts = "-eu";
        ifs = "\\n";
      };
      commands = {
        trash = "!trash $fx";
        delete = ''
          ''${{
            set -f
            printf "$fx\n"
            printf "delete?[y/n]"
            read ans
            [ $ans = "y" ] && rm -rf $fx
          }}
        '';
        z = ''
          %{{
            result="$(zoxide query --exclude $PWD $@ | sed 's/\\/\\\\/g;s/"/\\"/g')"
            lf -remote "send $id cd \"$result\""
          }}
        '';
        zi = ''
          ''${{
            result="$(zoxide query -i | sed 's/\\/\\\\/g;s/"/\\"/g')"
            lf -remote "send $id cd \"$result\""
          }}
        '';
      };
      extraConfig = ''
        %[ $LF_LEVEL -eq 1 ] || echo "Warning: You're in a nested lf instance!"
        $mkdir -p ~/.trash
      '';
    };

    programs.zoxide = mkIf cfg.full {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
      enableNushellIntegration = true;
    };

    programs.atuin = mkIf cfg.full {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
      enableNushellIntegration = true;
      flags = [ "--disable-up-arrow" ];
      settings = {
        auto_sync = false;
        update_check = false;
      };
    };

    programs.starship = mkIf cfg.full {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
      enableNushellIntegration = true;
      settings = {
        character = {
          success_symbol = "[λ](green bold)";
          error_symbol = "[λ](red bold)";
        };
        package = {
          disabled = true;
        };
        shell = {
          disabled = false;
          bash_indicator = "bash";
          format = "\\([$indicator]($style)\\) ";
        };
        docker_context = {
          disabled = true;
        };
        python = {
          detect_extensions = [ ];
        };
      };
    };

    programs.fzf = mkIf cfg.basic {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
    };

    programs.htop = mkIf cfg.basic {
      enable = true;
    };

    programs.password-store.enable = mkIf cfg.basic true;

    programs.alacritty = mkIf cfg.graphical {
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
        window = mkIf platform.isDarwin {
          option_as_alt = "OnlyLeft";
        };
      };
    };

    fonts.fontconfig.enable = mkIf (platform.isLinux && cfg.graphical) true;

    # programs.nix-index-database.comma.enable = true;

  };
}
