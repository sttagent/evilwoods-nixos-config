require('gitsigns').setup({
    numhl = true,
    current_line_blame = true,
})
vim.keymap.set('n', '<leader>hl', ':Gitsigns toggle_linehl<CR>')
