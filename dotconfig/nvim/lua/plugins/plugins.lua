return {
    --[[
    {
        'github/copilot.vim',
    },
    ]]

    {
        "sourcegraph/sg.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-telescope/telescope.nvim",
        },
        config = function()
            require('sg').setup({})
        end,
    },


    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        init = function()
            vim.o.timeout = true
            vim.o.timeoutlen = 300
        end,
        opts = {
            -- your configuration comes here
            -- or leave it empty to use the default settings
            -- refer to the configuration section below
        },
    },

    {
        "ellisonleao/gruvbox.nvim",
        priority = 1000,
        config = function ()
            vim.o.background = "dark"
            vim.cmd([[colorscheme gruvbox]])
        end},

    {
        'nvim-treesitter/nvim-treesitter-textobjects',
        dependencies = {'nvim-treesitter/nvim-treesitter'},
    },

    {
        'nvim-treesitter/nvim-treesitter',
        config = function()
            vim.opt.foldmethod = 'expr'
            vim.opt.foldexpr = 'nvim_treesitter#foldexpr()'
            vim.opt.foldenable = false

            require('nvim-treesitter.configs').setup({
                ensure_installed = 'all',
                highlight = {
                    enable = true,
                    additional_vim_regex_highlighting = false,
                },

                incremental_selection = {
                    enable = true,
                    keymaps = {
                    init_selection = "gnn", -- set to `false` to disable one of the mappings
                    node_incremental = "grn",
                    scope_incremental = "grc",
                    node_decremental = "grm",
                    },
                },
            })
        end,
        build = ':TSUpdate',
    },

    {
        'glepnir/dashboard-nvim',
        event = 'VimEnter',
        config = function()
            require('dashboard').setup {
            -- config
            }
        end,
        dependencies = { {'nvim-tree/nvim-web-devicons'}}
    },

    'ojroques/nvim-lspfuzzy',

    'machakann/vim-sandwich',

    'preservim/nerdcommenter',

    {
        'lewis6991/gitsigns.nvim',
        dependencies = {  'nvim-lua/plenary.nvim'  },
        config = function()
            require('gitsigns').setup({
                numhl = true,
                current_line_blame = true,
            })
        end
    },

    {
        'lukas-reineke/indent-blankline.nvim',
        config = function ()
            vim.opt.list = true
            vim.opt.listchars:append "space:⋅"
            vim.opt.listchars:append "eol:↴"
            require('ibl').setup({
                exclude = {
                    filetypes = { "dashboard" },
                },
            })
        end
    },

    {
        'hoob3rt/lualine.nvim'},
        dependencies = { 'kyazdani42/nvim-web-devicons' },
        config = function ()
            require('lualine').setup({
                options = { theme = 'gruvbox'},
            })
        end,
    {
        'kyazdani42/nvim-tree.lua',
        config = function()
            require("nvim-tree").setup()
            vim.keymap.set('n','<A-t>', ':NvimTreeToggle<CR>')
            vim.keymap.set('n','<Leader>t', ':NvimTreeFocus<CR>')
            vim.keymap.set('n','<Leader>n', ':NvimTreeFindFile<CR>')
        end
    },

    {
        'akinsho/nvim-bufferline.lua',
        config = function()
            require('bufferline').setup({
                options = {
                    offsets = { {filetype = "NvimTree", text = "File Explorer", text_align = "center" } },
                }
            })
        end,
    },

    {
    "nvim-neorg/neorg",
    build = ":Neorg sync-parsers",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("neorg").setup {
        load = {
          ["core.defaults"] = {}, -- Loads default behaviour
          ["core.concealer"] = {}, -- Adds pretty icons to your documents
          ["core.dirman"] = { -- Manages Neorg workspaces
            config = {
              workspaces = {
                notes = "~/Documents/Neorg-notes",
              },
            },
          },
        },
      }
    end,
    },
}
