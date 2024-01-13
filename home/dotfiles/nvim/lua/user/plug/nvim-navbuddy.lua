local navbuddy = require("nvim-navbuddy")

require("lspconfig").pyright.setup {
    on_attach = function(client, bufnr)
        navbuddy.attach(client, bufnr)
    end
}

vim.keymap.set('n', '<leader>n', '<cmd>Navbuddy<cr>')
