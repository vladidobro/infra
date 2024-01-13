{ pkgs, flake, flake-inputs, ... }:

{
  imports = [
    flake-inputs.index.hmModules.nix-index
  ];

  programs.nix-index-database.comma.enable = true;

  home.packages = with pkgs; [
    unzip
    unrar-wrapper
    p7zip
    highlight
    ripgrep
  ];

  # Shells

  programs.tmux = {
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

        set -g set-clipboard off  # macos
        #set -g set-clipboard on  # linux


        bind-key -T copy-mode-vi 'C-v' send -X rectangle-toggle
        bind-key -T copy-mode-vi V send -X select-line
        bind-key -T copy-mode-vi y send -X copy-pipe-and-cancel 'pbcopy'  # macos
        #bind-key -T copy-mode-vi y send -X copy-selection  # linus

        # See: https://github.com/christoomey/vim-tmux-navigator

        # decide whether we're in a Vim process
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

  programs.zsh = {
    enable = true;
  };

  programs.nushell = {
    enable = true;
    configFile.text = ''
      let config = {
        show_banner: false
      }

      $env.config = ($env.config? | default {} | merge $config)
    '';
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
    enableNushellIntegration = true;
  };

  programs.atuin = {
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

  programs.broot = {
    enable = true;
    # TODO: integragion
  };

  programs.git.delta.enable = true;
}
