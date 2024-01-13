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
