vim.g.mapleader = ' '

-- lazy plugin manager bootstrap
if vim.g.vscode then
  return
else
  local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
  if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
      "git",
      "clone",
      "--filter=blob:none",
      "https://github.com/folke/lazy.nvim.git",
      "--branch=stable", -- latest stable release
      lazypath,
    })
  end
  vim.opt.rtp:prepend(lazypath)

  require ('lazy').setup("plugins")
  -- end lazy plugin manager bootstrap

  -- file containing editor and UI config
  require('editor')

  -- file containing keybindings
  require('keybindings')

  -- vimscrypt autocommands
  require('autocommands')
end