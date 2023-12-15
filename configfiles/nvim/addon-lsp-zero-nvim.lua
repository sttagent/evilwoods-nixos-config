local lsp = require('lsp-zero').preset()

lsp.on_attach(function(client, bufnr)
    lsp.default_keymaps({ buffer = bufnr })
end)

require('lspconfig').lua_ls.setup(lsp.nvim_lua_ls())

require('lspconfig').nixd.setup(lsp.nvim_lua_ls())

require('lspconfig').ansiblels.setup(lsp.nvim_lua_ls())

require('lspconfig').pylyzer.setup(lsp.nvim_lua_ls())
