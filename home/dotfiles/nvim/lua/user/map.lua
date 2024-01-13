-- general
vim.keymap.set('n', '<leader>h', '<cmd>nohl<cr>')

-- make
vim.keymap.set('n', '<leader>m<leader>', '<cmd>!make<cr>')
vim.keymap.set('n', '<leader>mc', '<cmd>!make clean<cr>')
vim.keymap.set('n', '<leader>ma', '<cmd>!make all<cr>')
vim.keymap.set('n', '<leader>mt', '<cmd>!make test<cr>')
vim.keymap.set('n', '<leader>md', '<cmd>!make dev<cr>')

vim.keymap.set('n', '<leader>v<leader>', '<cmd>!vmake<cr>')
vim.keymap.set('n', '<leader>vc', '<cmd>!vmake clean<cr>')
vim.keymap.set('n', '<leader>va', '<cmd>!vmake all<cr>')
vim.keymap.set('n', '<leader>vt', '<cmd>!vmake test<cr>')
vim.keymap.set('n', '<leader>vd', '<cmd>!vmake dev<cr>')

-- navigating buffers
-- would like <A-p> and <A-n>
vim.keymap.set('n', '<leader>[', '<cmd>bprevious<cr>')
vim.keymap.set('n', '<leader>]', '<cmd>bnext<cr>')
