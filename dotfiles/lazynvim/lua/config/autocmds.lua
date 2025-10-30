-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

local function should_autosave(buf)
  local name = vim.api.nvim_buf_get_name(buf)
  local fs_stat = vim.uv.fs_stat(name)
  local modified = vim.bo[buf].modified
  local type = vim.bo[buf].buftype
  local readonly = vim.bo[buf].readonly

  return type == "" and name ~= "" and modified and not readonly and fs_stat and fs_stat.type == "file"
end

local autosave_group = vim.api.nvim_create_augroup("autosave", { clear = true })
vim.api.nvim_create_autocmd({ "WinLeave" }, {
  group = autosave_group,
  pattern = "*",
  callback = function()
    if should_autosave(vim.api.nvim_get_current_buf()) then
      LazyVim.format.format()
      vim.cmd("silent! write")
    end
  end,
})

vim.api.nvim_create_autocmd("FocusLost", {
  group = autosave_group,
  pattern = "*",
  callback = function()
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
      if vim.api.nvim_buf_is_loaded(buf) and should_autosave(buf) then
        vim.api.nvim_buf_call(buf, function()
          LazyVim.format.format({ buf = buf })
          vim.cmd("silent! write")
        end)
      end
    end
  end,
})
