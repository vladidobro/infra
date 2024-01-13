require('nvim-tmux-navigation').setup({
    disable_when_zoomed = true, -- defaults to false
})

local nvim_tmux = require('nvim-tmux-navigation')

vim.keymap.set({'n', 't', 'i'}, "<A-h>", nvim_tmux.NvimTmuxNavigateLeft)
vim.keymap.set({'n', 't', 'i'}, "<A-j>", nvim_tmux.NvimTmuxNavigateDown)
vim.keymap.set({'n', 't', 'i'}, "<A-k>", nvim_tmux.NvimTmuxNavigateUp)
vim.keymap.set({'n', 't', 'i'}, "<A-l>", nvim_tmux.NvimTmuxNavigateRight)
vim.keymap.set({'n', 't', 'i'}, "<A-\\>", nvim_tmux.NvimTmuxNavigateLastActive)
vim.keymap.set({'n', 't', 'i'}, "<A-Space>", nvim_tmux.NvimTmuxNavigateNext)
