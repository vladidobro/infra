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

  keymaps = [
    { mode = "n"; key = "<leader>bb"; action = "<cmd>DapToggleBreakpoint<cr>"; options.desc = "Toggle breakpoint"; }
    { mode = "n"; key = "<leader>bc"; action = "<cmd>DapContinue<cr>"; options.desc = "Continue/Start"; }
    { mode = "n"; key = "<leader>bs"; action = "<cmd>DapStepInto<cr>"; options.desc = "Step into"; }
    { mode = "n"; key = "<leader>bn"; action = "<cmd>DapStepOver<cr>"; options.desc = "Step over"; }
    { mode = "n"; key = "<leader>bu"; action = "<cmd>DapStepOut<cr>"; options.desc = "Step out"; }
    { mode = "n"; key = "<leader>bt"; action = "<cmd>DapTerminate<cr>"; options.desc = "Terminate"; }
    { mode = "n"; key = "<leader>bi"; action = "<cmd>lua require('dapui').toggle()<cr>"; options.desc = "Toggle UI"; }
  ];

  plugins = {
    web-devicons.enable = true;
    lualine.enable = true;
    which-key.enable = true;
    nvim-tree = {
      enable = true;
      openOnSetup = true;
      luaConfig.post = ''
        vim.keymap.set('n', '<leader>e', '<cmd>NvimTreeToggle<cr>')
      '';
    };

    lsp = {
      servers = {
	pyright.enable = true;
	ruff.enable = true;
      };
      enable = true;
      keymaps = {
        lspBuf = {
          gd = "definition";
          gr = "references";
          gD = "declaration";
          gI = "implementation";
          gT = "type_definition";
          K = "hover";
          "<leader>lw" = "workspace_symbol";
          "<leader>lr" = "rename";
	  "<leader>ls" = "signature_help";
	  "<leader>la" = "code_action";
	  "<leader>lf" = "format";
        };
        diagnostic = {
          "<leader>d" = "open_float";
          "[d" = "goto_prev";
          "]d" = "goto_next";
        };
      };
    };

    conform-nvim = {
      enable = true;
      settings = {
        formatters_by_ft = {
	  python = [ "ruff_format" ];
	};
	format_on_save = {
	  lsp_fallback = true;
	  timeout_ms = 500;
	};
      };
    };

    comment.enable = true;
    luasnip.enable = true;

    dap.enable = true;
    dap-python.enable = true;
    dap-ui.enable = true;
  
    cmp = {
      enable = true;
      autoEnableSources = true;
      settings = {
        sources = [
	    { name = "nvim_lsp"; priority = 1000; }
	    { name = "luasnip"; priority = 750; }
	    { name = "path"; priority = 500; }
	    { name = "buffer"; priority = 250; }
	];

	#snippet.expand = "function(args) require('luasnip').lsp_expand(args.body) end";

	mapping = {
	  "<C-n>" = "cmp.mapping.select_next_item()";
	  "<C-p>" = "cmp.mapping.select_prev_item()";
	  "<C-l>" = "cmp.mapping.confirm({ select = true })";
	  "<C-d>" = "cmp.mapping.scroll_docs(4)";
	  "<C-u>" = "cmp.mapping.scroll_docs(-4)";
	  "<C-e>" = "cmp.mapping.close()";
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
    packages.nvim = inputs'.nixvim-2605.legacyPackages.makeNixvim vim;
  };
}
