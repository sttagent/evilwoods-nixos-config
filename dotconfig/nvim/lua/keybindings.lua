vim.keymap.set('n', '<Leader>ec', ':tabedit $MYVIMRC<CR>', { silent = true })
vim.keymap.set('n', '<Leader>ek', ':tabedit $HOME/.config/nvim/lua/keybindings.lua<CR>', { silent = true })
vim.keymap.set('n', '<Leader>ep', ':tabedit $HOME/.config/nvim/lua/plugins.lua<CR>', { silent = true })
vim.keymap.set('n', '<Leader>cr', ':luafile $MYVIMRC<CR>', { silent = true })
vim.keymap.set('n', '<C-.>', ':make<CR>', {silent = true})
-- selects text of last input command
vim.keymap.set('n', 'gV', '`[v`]')

vim.keymap.set('', '<C-h>', '<C-w>h', { silent = true })
vim.keymap.set('', '<C-j>', '<C-w>j', { silent = true })
vim.keymap.set('', '<C-k>', '<C-w>k', { silent = true })
vim.keymap.set('', '<C-l>', '<C-w>l', { silent = true })

vim.keymap.set('', '<C-Left>', ':vertical resize +3<CR>', { silent = true })
vim.keymap.set('', '<C-Right>', ':vertical resize -3<CR>', { silent = true })
vim.keymap.set('', '<C-Up>', ':resize +3<CR>', { silent = true })
vim.keymap.set('', '<C-Down>', ':resize -3<CR>', { silent = true })

vim.keymap.set('n', '<Leader><Space>', ':set nohlsearch<CR>')

-- FTerm
vim.keymap.set('n', '<A-i>', '<CMD>lua require("FTerm").toggle()<CR>', { silent = true })
vim.keymap.set('t', '<A-i>', '<C-\\><C-n><CMD>lua require("FTerm").toggle()<CR>', { silent = true })

-- GitSigns
vim.keymap.set('n', '<leader>hl', ':Gitsigns toggle_linehl<CR>')

-- BufferLine
vim.keymap.set('n','<A-b>', ':BufferLinePick<CR>')
vim.keymap.set('n','<A-n>', ':BufferLineCyclePrev<CR>')
vim.keymap.set('n','<A-e>', ':BufferLineCycleNext<CR>')
vim.keymap.set('n','<A-r>', ':BufferLinePickClose<CR>')

-- telescope.nvim
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Find Files' })
vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Live Grep' })
vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Buffers' })
vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Help Tags' })
vim.keymap.set('n', '<leader>fo', builtin.vim_options, { desc = 'Vim Options' })
vim.keymap.set('n', '<leader>fs', builtin.lsp_document_symbols, {
    desc = 'Document Symbols',
})
