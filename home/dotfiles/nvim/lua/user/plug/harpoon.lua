local ui = require('harpoon.ui')
local mark = require('harpoon.mark')


vim.keymap.set('n', '<leader>-', ui.nav_next)
vim.keymap.set('n', '<leader>=', ui.nav_prev)
vim.keymap.set('n', '<leader>p<leader>', ui.toggle_quick_menu)
vim.keymap.set('n', '<leader>pa', mark.add_file)

function nav_fn(index) return function() ui.nav_file(index) end end
vim.keymap.set('n', '<leader>p1', nav_fn(1))
vim.keymap.set('n', '<leader>p2', nav_fn(2))
vim.keymap.set('n', '<leader>p3', nav_fn(3))
vim.keymap.set('n', '<leader>p4', nav_fn(4))
vim.keymap.set('n', '<leader>p5', nav_fn(5))
vim.keymap.set('n', '<leader>p6', nav_fn(6))
vim.keymap.set('n', '<leader>p7', nav_fn(7))
vim.keymap.set('n', '<leader>p8', nav_fn(8))
vim.keymap.set('n', '<leader>p9', nav_fn(9))
vim.keymap.set('n', '<leader>p0', nav_fn(10))
