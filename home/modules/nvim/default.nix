{ flake, config, pkgs, ... }:

{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    extraLuaConfig = ''
      --- system
      vim.opt.encoding = 'UTF-8'
      vim.opt.swapfile = true
      vim.opt.ttyfast = true
      vim.opt.autoread = true

      --- behaviour
      vim.opt.autoindent = true
      vim.opt.mouse = 'a'
      vim.opt.scrolloff = 10
      vim.opt.splitright = true
      vim.opt.splitbelow = true
      vim.opt.foldmethod = 'indent'

      --- searching
      vim.opt.showmatch = true
      vim.opt.ignorecase = true
      vim.opt.smartcase = true
      vim.opt.hlsearch = true
      vim.opt.incsearch = true

      --- tabs
      vim.opt.shiftwidth = 4
      vim.opt.tabstop = 4
      vim.opt.softtabstop = 4
      vim.opt.expandtab = true

      --- appearance
      vim.opt.cursorline = true
      vim.opt.wrap = true
      vim.opt.breakindent = true
      vim.opt.termguicolors = true
      vim.opt.background= 'dark'

      --- line number
      vim.opt.number = true
      vim.opt.relativenumber = true

      -- completion
      -- vim.opt.completeopt = 'menu' TODO

      -- leader
      vim.g.mapleader = " "

      -- map
      vim.keymap.set('n', '<leader>h', '<cmd>nohl<cr>')

      -- navigating buffers
      vim.keymap.set('n', '<leader>[', '<cmd>bprevious<cr>')
      vim.keymap.set('n', '<leader>]', '<cmd>bnext<cr>')
    '';

    plugins = with pkgs.vimPlugins; [
      { 
        plugin = nvim-tree-lua;
        config = ''
          require('nvim-tree').setup()
          vim.keymap.set('n', '<leader>e', '<cmd>NvimTreeToggle<cr>')
        '';
        type = "lua";
      }
      { 
        plugin = gruvbox-nvim;
        config = ''
          colorscheme gruvbox
        '';
      }
      { 
        plugin = telescope-nvim;
        config = ''
          local builtin = require('telescope.builtin')
          vim.keymap.set('n', '<leader>f', builtin.find_files, {})
          vim.keymap.set('n', '<leader>g', builtin.live_grep, {})
          vim.keymap.set('n', '<leader>b', builtin.buffers, {})
        '';
        type = "lua";
      }
      {
        plugin = nvim-lspconfig;
        config = ''
          local lspconfig = require('lspconfig')

          lspconfig.pyright.setup {}
          lspconfig.rust_analyzer.setup {}
          lspconfig.hls.setup {}
          lspconfig.nushell.setup {}

          vim.keymap.set('n', '<space>d', vim.diagnostic.open_float)
          vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
          vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
          vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist)

          vim.api.nvim_create_autocmd('LspAttach', {
            group = vim.api.nvim_create_augroup('UserLspConfig', {}),
            callback = function(ev)
              -- vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'  -- TODO

              local opts = { buffer = ev.buf }
              vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
              vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
              vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
              vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
              vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
              vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
              vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
              vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
              vim.keymap.set({'n', 'v'}, '<space>ca', vim.lsp.buf.code_action, opts)
              vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
              vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
              vim.keymap.set('n', '<space>wl', function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end, opts)
              -- vim.keymap.set('n', '<space>f', function() vim.lsp.buf.format { async = true } end, opts)
            end,
          })

          vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(
            vim.lsp.handlers.hover,
            {border = 'rounded'}
          )
           
          vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(
            vim.lsp.handlers.signature_help,
            {border = 'rounded'}
          )
        '';
        type = "lua";
      }
      {
        plugin = lualine-nvim;
        config = ''
          require('lualine').setup({
            options = {
              -- icons_enabled = false,
              section_separators = "",
              component_separators = ""
            }
          })
        '';
        type = "lua";
      }
      {
        plugin = toggleterm-nvim;
        config = ''
          require('toggleterm').setup({
            open_mapping = '<C-g>',
            direction = 'horizontal',
            shade_terminals = true
          })
        '';
        type = "lua";
      }
      {
        plugin = tmux-nvim;
        config = ''
          local tmux = require('tmux')
          tmux.setup({
            navigation = { enable_default_keybindings = false, },
            resize = { enable_default_keybindings = false, },
          })
          vim.keymap.set({'n', 't', 'i'}, '<A-h>', tmux.move_left)
          vim.keymap.set({'n', 't', 'i'}, '<A-j>', tmux.move_bottom)
          vim.keymap.set({'n', 't', 'i'}, '<A-k>', tmux.move_top)
          vim.keymap.set({'n', 't', 'i'}, '<A-l>', tmux.move_right)
        '';
        type = "lua";
      }
      nvim-web-devicons
      cmp-nvim-lsp
      cmp-path
      cmp-buffer
      cmp-cmdline
      {
        plugin = nvim-cmp;
        config = ''
          local cmp = require'cmp'

          cmp.setup({
            snippet = {
              -- REQUIRED - you must specify a snippet engine
              expand = function(args)
                vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
                -- require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
                -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
                -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
              end,
            },
            window = {
              -- completion = cmp.config.window.bordered(),
              -- documentation = cmp.config.window.bordered(),
            },
            mapping = cmp.mapping.preset.insert({
              ['<C-b>'] = cmp.mapping.scroll_docs(-4),
              ['<C-f>'] = cmp.mapping.scroll_docs(4),
              ['<C-Space>'] = cmp.mapping.complete(),
              ['<C-e>'] = cmp.mapping.abort(),
              ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
            }),
            sources = cmp.config.sources({
              { name = 'nvim_lsp' },
              -- { name = 'vsnip' }, -- For vsnip users.
              -- { name = 'luasnip' }, -- For luasnip users.
              -- { name = 'ultisnips' }, -- For ultisnips users.
              -- { name = 'snippy' }, -- For snippy users.
            }, {
              { name = 'buffer' },
            })
          })

          -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
          cmp.setup.cmdline({ '/', '?' }, {
            mapping = cmp.mapping.preset.cmdline(),
            sources = {
              { name = 'buffer' }
            }
          })

          -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
          cmp.setup.cmdline(':', {
            mapping = cmp.mapping.preset.cmdline(),
            sources = cmp.config.sources({
              { name = 'path' }
            }, {
              { name = 'cmdline' }
            })
          })

          -- Set up lspconfig.
          local capabilities = require('cmp_nvim_lsp').default_capabilities()
          require('lspconfig')['pyright'].setup {
            capabilities = capabilities
          }

          --
          -- cmp.setup({
            -- snippet = {
              -- expand = function(args)
                -- luasnip.lsp_expand(args.body)
              -- end
            -- },
            -- sources = {
            -- {name = 'path'},
            -- {name = 'nvim_lsp', keyword_length = 3},
            -- {name = 'buffer', keyword_length = 3},
            -- {name = 'luasnip', keyword_length = 2},
            -- },
            -- window = {
              -- documentation = cmp.config.window.bordered()
            -- },
            -- formatting = {
              -- fields = {'menu', 'abbr', 'kind'},
              -- format = function(entry, item)
                -- local menu_icon = {
                  -- nvim_lsp = 'λ',
                  -- luasnip = '⋗',
                  -- buffer = 'Ω',
                  -- path = '🖫',
                -- }
          -- 
                -- item.menu = menu_icon[entry.source.name]
                -- return item
              -- end,
            -- },
            -- mapping = {
              -- ['<CR>'] = cmp.mapping.confirm({select = false}),
              -- ['<Up>'] = cmp.mapping.select_prev_item(select_opts),
              -- ['<Down>'] = cmp.mapping.select_next_item(select_opts),
              -- ['<C-p>'] = cmp.mapping.select_prev_item(select_opts),
              -- ['<C-n>'] = cmp.mapping.select_next_item(select_opts),
              -- ['<C-u>'] = cmp.mapping.scroll_docs(-4),
              -- ['<C-f>'] = cmp.mapping.scroll_docs(4),
              -- ['<C-e>'] = cmp.mapping.abort(),
              -- ['<C-d>'] = cmp.mapping(function(fallback)
                -- if luasnip.jumpable(1) then
                  -- luasnip.jump(1)
                -- else
                  -- fallback()
                -- end
              -- end, {'i', 's'}),
              -- ['<C-b>'] = cmp.mapping(function(fallback)
                -- if luasnip.jumpable(-1) then
                  -- luasnip.jump(-1)
                -- else
                  -- fallback()
                -- end
              -- end, {'i', 's'}),
              -- ['<Tab>'] = cmp.mapping(function(fallback)
                -- local col = vim.fn.col('.') - 1
          -- 
                -- if cmp.visible() then
                  -- cmp.select_next_item(select_opts)
                -- elseif col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') then
                  -- fallback()
                -- else
                  -- cmp.complete()
                -- end
              -- end, {'i', 's'}),
              -- ['<S-Tab>'] = cmp.mapping(function(fallback)
                -- if cmp.visible() then
                  -- cmp.select_prev_item(select_opts)
                -- else
                  -- fallback()
                -- end
              -- end, {'i', 's'}),
            -- }
          -- })
          -- TODO

        '';
        type = "lua";
      }
      plenary-nvim
      nvim-navic
      nui-nvim
      {
        plugin = nvim-navbuddy;
        config = ''
          local navbuddy = require("nvim-navbuddy")
          require("lspconfig").pyright.setup {
              on_attach = function(client, bufnr)
                  navbuddy.attach(client, bufnr)
              end
          }
          vim.keymap.set('n', '<leader>s', '<cmd>Navbuddy<cr>')
        '';
        type = "lua";
      }
      {
        plugin = nvim-dap;
        config = ''
          -- TODO
        '';
        type = "lua";
      }
      {
        plugin = nvim-dap-ui;
        config = ''
          -- TODO
        '';
        type = "lua";
      }
      {
        plugin = nvim-dap-python;
        config = ''
          -- TODO
        '';
        type = "lua";
      }
      nvim-treesitter
      nvim-treesitter-textobjects
      {
        plugin = nvim-surround;
        config = ''
          -- TODO
        '';
        type = "lua";
      }
    ];
  };
}
