{ inputs, self, ... }:
let 
vim = { lib, config, pkgs, ... }: {
  opts = {
    number = true;
    relativenumber = true;
    shiftwidth = 4;
  };
  globals = {
    mapleader = " ";
  };

  colorschemes.gruvbox.enable = true;

  extraPlugins = with pkgs.vimPlugins; [
    gruvbox
  ];

  plugins = {
    web-devicons.enable = true;
    lualine.enable = true;
    nvim-tree = {
      enable = true;
      openOnSetup = true;
      luaConfig.post = ''
        vim.keymap.set('n', '<leader>e', '<cmd>NvimTreeToggle<cr>')
      '';
    };
    lsp = {
      enable = true;
      servers = {
        pyright.enable = true;
      };
      keymaps = {
        lspBuf = {
          gd = "definition";
          gr = "references";
          gD = "declaration";
          gI = "implementation";
          gT = "type_definition";
          K = "hover";
          "<leader>cw" = "workspace_symbol";
          "<leader>cr" = "rename";
        };
        diagnostic = {
          "<leader>cd" = "open_float";
          "[d" = "goto_next";
          "]d" = "goto_prev";
        };
      };
    };
    toggleterm = {
      enable = true;
      settings = {
        open_mapping = "'<C-g>'";
        direction = "horizontal";
      };
    };
    tmux-navigator = {
      enable = true;
      keymaps = [
        { action = "left"; key = "<A-h>"; }
        { action = "down"; key = "<A-j>"; }
        { action = "up"; key = "<A-k>"; }
        { action = "right"; key = "<A-l>"; } 
      ];
      settings = {
        no_mappings = 1;
      };
    };
    telescope = {
      enable = true;
      keymaps = {
        "<leader>fg" = "live_grep";
        "<leader>ff" = "git_files";
        "<leader>fh" = "find_files";
        "<leader>fb" = "buffers";
      };
    };

    treesitter.enable = true;
    treesitter-textobjects = {
      enable = true;
      settings = {
        select = {
          enable = true;
          lookahead = true;
          keymaps = {
            "af" = "@function.outer";
            "if" = "@function.inner";
            "ac" = "@class.outer";
            "ic" = "@class.inner";
          };
          selection_modes = {
            "@function.outer" = "V";
            "@class.outer" = "V";
          };
        };
        move = {
          enable = true;
          set_jumps = true;
          goto_next_start = {
            "]f" = "@function.outer";
            "]c" = "@class.outer";
          };
          goto_previous_start = {
            "[f" = "@function.outer";
            "[c" = "@class.outer";
          };
        };
      };
    };

    # - [ ] cmp
    #   - [ ] lsp
    #   - [ ] path
    #   - [ ] buffer
    #   - [ ] cmdline
    # - [ ] extras
    #   - [ ] plenary
    #   - [ ] navic
    #   - [ ] nui
    #   - [ ] navbuddy
  };
};
in {
  flake.nixvimModules.default = vim;
  perSystem = { config, pkgs, inputs', ... }: {
    packages.nvim = inputs'.nixvim-2505.legacyPackages.makeNixvim vim;
  };
}
