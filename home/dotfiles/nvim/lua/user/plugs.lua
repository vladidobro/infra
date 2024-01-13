require('user.plug.packer')

require('packer').startup(function(use)
  use 'wbthomason/packer.nvim'

  -- core
  use 'alexghergh/nvim-tmux-navigation'
  use 'nvim-lua/plenary.nvim'

  -- ui
  use 'nvim-telescope/telescope.nvim'
  use 'nvim-tree/nvim-tree.lua'
  use 'akinsho/toggleterm.nvim'
  use 'ThePrimeagen/harpoon'
--  use 'folke/zen-mode.nvim'
--  use 'ellisonleao/glow.nvim'
--  use 'iamcco/markdown-preview.nvim'
  use 'SmiteshP/nvim-navic' -- lsp status bar
  use 'MunifTanjim/nui.nvim' -- ui elements

  -- language
  use 'neovim/nvim-lspconfig'
  use 'mhartington/formatter.nvim'
  use 'nvim-treesitter/nvim-treesitter'
  use 'nvim-treesitter/nvim-treesitter-textobjects'
  use 'simrat39/symbols-outline.nvim' 
  use 'SmiteshP/nvim-navbuddy'
  use 'numToStr/Comment.nvim'
  use 'mfussenegger/nvim-dap'

  -- snippets
--  use 'SirVer/UltiSnips'
--  use 'L3MON4D3/LuaSnip'
--  use 'rafamadriz/friendly-snippets'
--  use 'saadparwaiz1/cmp_luasnip'

  -- completion
  use 'hrsh7th/nvim-cmp'
  use 'hrsh7th/cmp-buffer'
  use 'hrsh7th/cmp-path'
  use 'hrsh7th/cmp-nvim-lsp'
  use 'hrsh7th/cmp-cmdline'

  -- appearance
  use 'nvim-lualine/lualine.nvim'
  use 'nvim-tree/nvim-web-devicons'

  -- themes
  use 'joshdick/onedark.vim'
  use 'tanvirtin/monokai.nvim'
  use 'folke/tokyonight.nvim'
  use 'ellisonleao/gruvbox.nvim'
  use 'sainnhe/sonokai'
  use { "catppuccin/nvim", as = "catppuccin" }
  use 'maxmx03/solarized.nvim'

  if packer_bootstrap then
    require('packer').sync()
  end
end)

require('user.plug.lspconfig')
require('user.plug.lualine')
require('user.plug.nvim-tree')
require('user.plug.toggleterm')
require('user.plug.formatter')
require('user.plug.nvim-tmux-navigation')
require('user.plug.cmp')
require('user.plug.luasnip')
require('user.plug.telescope')
require('user.plug.nvim-navbuddy')
require('user.plug.harpoon')
require('user.plug.symbols-outline')

-- use 'wellle/targets.vim'
-- use 'tpope/vim-repeat'
-- use 'tpope/vim-fugitive'
-- use 'kylechui/nvim-surround'
