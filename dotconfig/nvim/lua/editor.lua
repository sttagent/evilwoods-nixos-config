local utils = require('utils')
local cmd = vim.cmd
local opt = vim.opt

---- UI start ----
opt.number = true
opt.relativenumber = true
opt.termguicolors = true
opt.termguicolors = true
opt.wildmenu = true
opt.colorcolumn = '88'
opt.cursorline = true
-- opt.cursorcolumn = true
opt.wrap =  false
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

