require('bufferline').setup({
    options = {
        offsets = { { filetype = "NvimTree", text = "File Explorer", text_align = "center" } },
    }
})
-- BufferLine keybindings
vim.keymap.set('n','<A-b>', ':BufferLinePick<CR>')
vim.keymap.set('n','<A-n>', ':BufferLineCyclePrev<CR>')
vim.keymap.set('n','<A-e>', ':BufferLineCycleNext<CR>')
vim.keymap.set('n','<A-r>', ':BufferLinePickClose<CR>')
