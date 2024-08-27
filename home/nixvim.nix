{ config, pkgs, ... }:

{

  config = {
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
      lualine.enable = true;            # statusline
      treesitter.enable = true;         # ast
      treesitter-textobjects.enable = true;  # 
      nvim-tree.enable = true;          # file manager sidebar
      luasnip.enable = true;            # snippets  TODO
#      magma-nvim.enable = true;         # jupyter   TODO
#      nix.enable = true;                # NixEdit to open nixpkgs def
#      navbuddy.enable = true;           # symbol explorer
#      gitmessenger.enable = true;       # reveal commit message for line
#      gitblame.enable = true;           # blame line
#      gitconflict.enable = true;        # git conflict
      undotree.enable = true;           # undo changes
#      # treesitter-textobjects
#      # nvim-surround
#      # telescope-nvim
#      # nvim-tree-lua
#      # lualine
#      # toggleterm-nvim
#      # tmux-nvim
#      # nvim-cmp
#      # nvim-dap{,-ui,-python}
#
#      # plenary-nvim
#      # nvim-navic
#      # nui-nvim
      dap = {
        enable = true; # TODO
      };
      lsp-format.enable = true;         # autoformat
      lsp = {
        enable = true;
        servers = {
#          lua-ls.enable = true;         # lua
#          nil-ls.enable = true;         # nix
          nixd.enable = true;           # nix
#          rnix-lsp.enable = true;       # nix
#          pylsp.enable = true;          # python
#          pylyzer.enable = true;        # python
          pyright.enable = true;        # python
          ruff.enable = true;           # python
#          ruff-lsp.enable = true;       # python
          rust-analyzer.enable = true;  # rust
          rust-analyzer.installCargo = false;
          rust-analyzer.installRustc = false;
          hls.enable = true;            # haskell
#          ccls.enable = true;           # c
          clangd.enable = true;         # c
          sqls.enable = true;           # sql
#          cmake.enable = true;          # cmake
#          dockerls.enable = true;       # docker
          bashls.enable = true;         # bash
#          nushell.enable = true;        # nushell
#          bufls.enable = true;          # protobuf
#          beancount.enable = true;      # beancount TODO accounting
#          texlab.enable = true;         # tex
#          digestif.enable = true;       # tex
#          ltex.enable = true;           # tex, markdown
#          marksman.enable = true;       # markdown
#          lemminx.enable = true;        # xml
#          html.enable = true;           # html
          yamlls.enable = true;         # yaml
          taplo.enable = true;          # toml
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
    };

  };
}
