return {
    {
        'nvim-telescope/telescope-fzf-native.nvim',
        build = 'make',
    },

    {
        'nvim-telescope/telescope.nvim',
        branch = '0.1.x',
        --tag = '0.1.1',
        dependencies = {
            'nvim-lua/plenary.nvim',
        },
        config = function ()
            require('telescope').setup({})

            require('telescope').load_extension('fzf')
        end
    }
}
