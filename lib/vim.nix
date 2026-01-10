{ inputs, self, ... }:
let 
lsp = {
    enable = true;
    servers = {
      pyright.enable = true;
      ruff.enable = true;
      #ruff-lsp.enable = true;
      rust-analyzer.enable = true;
      rust-analyzer.installCargo = false;
      rust-analyzer.installRustc = false;
      hls.enable = true;
      clangd.enable = true;
      sqls.enable = true;
      #dockerls.enable = true;
      bashls.enable = true;
      #nushell.enable = true;
      #beancount.enable = true;
      #lemminx.enable = true;  # xml
      #html.enable = true;
      yamlls.enable = true;
      taplo.enable = true;
      #ziggy.enable=true;
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
vim = { lib, config, pkgs, ... }: {
  opts = {
    number = true;
    relativenumber = true;
    shiftwidth = 4;
  };
  globals = {
    mapleader = " ";
  };
  keymaps = [
    { mode = "n"; key = "<leader>mk"; action = "<cmd>!make<cr>"; }
  ];

  colorschemes.gruvbox.enable = true;

  extraPlugins = with pkgs.vimPlugins; [
    gruvbox
  ];

  plugins = {
    lualine.enable = true;
    treesitter.enable = true;
    treesitter-textobjects.enable = true;
    nvim-tree.enable = true;
    luasnip.enable = true;
    #toggleterm-nvim.enable = true;
    #telescope-nvim.enable = true;
    #navbuddy.enable = true;
    #undotree.enable = true;
    #nvim-surround
    #nvim-tree-lua
    #tmux-nvim
    #nvim-cmp
    #nvim-dap{,-ui,-python}
    #plenary-nvim
    #nvim-navic
    #nui-nvim
    dap.enable = true;
    lsp-format.enable = true;         # autoformat
    lsp = lsp;
  };
};
in {
  flake.nixvimModules.default = vim;
  perSystem = { config, pkgs, inputs', ... }: {
    packages.nvim = inputs'.nixvim-2505.legacyPackages.makeNixvim vim;
  };
}
