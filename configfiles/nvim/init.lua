if vim.g.vscode then
    return
else
    local cmd = vim.cmd
    local opt = vim.opt
    local caucmd = vim.api.nvim_create_autocmd
    vim.g.gruvbox_material_background = "hard"
    -- vim.g.gruvbox_material_better_performance = 1
    vim.opt.background = "dark"
    vim.cmd([[ colorscheme gruvbox-material ]])
    vim.g.mapleader = " "

    ---- UI start ----
    opt.number = true
    opt.relativenumber = true
    opt.termguicolors = true
    opt.termguicolors = true
    opt.wildmenu = true
    opt.colorcolumn = '88'
    opt.cursorline = true
    -- opt.cursorcolumn = true
    opt.wrap = false
    opt.autowrite = true

    -- tabs
    opt.expandtab = true
    opt.smarttab = true
    opt.tabstop = 4
    opt.shiftwidth = 4
    opt.softtabstop = 4

    -- search
    opt.ignorecase = true

    opt.list = true

    -- folding
    -- taking care of by nvim treesiter
    -- opt.foldmethod = 'indent'
    -- opt.foldlevelstart = 10
    -- opt.foldnestmax = 10

    opt.splitbelow = true
    opt.splitright = true
    ---- UI end ----
    --
    -- custom keybindings
    vim.keymap.set('n', '<Leader><Space>', ':set nohlsearch<CR>')
    vim.keymap.set('n', 'gV', '`[v`]')

    vim.keymap.set('', '<C-h>', '<C-w>h', { silent = true })
    vim.keymap.set('', '<C-j>', '<C-w>j', { silent = true })
    vim.keymap.set('', '<C-k>', '<C-w>k', { silent = true })
    vim.keymap.set('', '<C-l>', '<C-w>l', { silent = true })

    vim.keymap.set('', '<C-Left>', ':vertical resize +3<CR>', { silent = true })
    vim.keymap.set('', '<C-Right>', ':vertical resize -3<CR>', { silent = true })
    vim.keymap.set('', '<C-Up>', ':resize +3<CR>', { silent = true })
    vim.keymap.set('', '<C-Down>', ':resize -3<CR>', { silent = true })

    -- autocommads
    caucmd("FileType", {
        pattern = "nix",
        callback = function()
            opt.tabstop = 2
            opt.shiftwidth = 2
            opt.softtabstop = 2
        end
    })
    -- end autocommands
end
