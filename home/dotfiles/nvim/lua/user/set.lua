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
vim.cmd('colorscheme gruvbox')

--- line number
vim.opt.number = true
vim.opt.relativenumber = true

-- completion
vim.opt.completeopt = 'menu'

-- leader
vim.g.mapleader = " "
