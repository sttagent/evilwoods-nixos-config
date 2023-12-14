return {
    {
        'VonHeikemen/lsp-zero.nvim',
        branch = 'v2.x',
        dependencies = {
            -- LSP Support
            {'neovim/nvim-lspconfig'},             -- Required
            {'williamboman/mason.nvim'},           -- Optional
            {'williamboman/mason-lspconfig.nvim'}, -- Optional

            -- Autocompletion
            {'hrsh7th/nvim-cmp'},     -- Required
            {'hrsh7th/cmp-nvim-lsp'}, -- Required
            {'L3MON4D3/LuaSnip'},     -- Required
        },
        config = function ()
            local lsp = require('lsp-zero').preset()

            lsp.on_attach(function(client, bufnr)
                lsp.default_keymaps({buffer = bufnr})
            end)

            require('lspconfig').lua_ls.setup(lsp.nvim_lua_ls())

            require('lspconfig').ansiblels.setup(lsp.nvim_lua_ls())

            require('lspconfig').pylsp.setup(lsp.nvim_lua_ls())
        end
    }
}