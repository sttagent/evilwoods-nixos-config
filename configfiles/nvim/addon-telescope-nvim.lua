require('telescope').setup({})
require('telescope').load_extension('fzf')

-- Telescope keybindings
local tb = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', tb.find_files, { desc = 'Find files' })
vim.keymap.set('n', '<leader>fg', tb.live_grep, {})
vim.keymap.set('n', '<leader>fb', tb.buffers, {})
vim.keymap.set('n', '<leader>fh', tb.help_tags, {})
vim.keymap.set('n', '<leader>fo', tb.vim_options, {})
vim.keymap.set('n', '<leader>fs', tb.lsp_document_symbols, {})
