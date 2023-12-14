{ config
, pkgs
, lib
, ...
}: {
  home-manager.programs.neovim = {
    plugins = with pkgs.vimPlugins; [
      nvim-web-devicons
      plenary-nvim
      gruvbox-nvim

      {
        plugin = nvim-treesitter.withAllGrammars;
        type = "lua";
        config = /* lua */ ''
          vim.opt.foldmethod = 'expr'
          vim.opt.foldexpr = 'nvim_treesitter#foldexpr()'
          vim.opt.foldenable = false

          require('nvim-treesitter.configs').setup({
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
        '';
      }
      nvim-treesitter-textobjects
      nvim-treesitter-context

      nvim-lspconfig
      {
        plugin = lsp-zero-nvim;
        type = "lua";
        config = /* lua */ ''
          local lsp = require('lsp-zero').preset()

          lsp.on_attach(function(client, bufnr)
            lsp.default_keymaps({buffer = bufnr})
          end)

          require('lspconfig').lua_ls.setup(lsp.nvim_lua_ls())

          require('lspconfig').nixd.setup(lsp.nvim_lua_ls())

          require('lspconfig').ansiblels.setup(lsp.nvim_lua_ls())

          require('lspconfig').pylyzer.setup(lsp.nvim_lua_ls())
        '';
      }

      {
        plugin = copilot-lua;
        type = "lua";
        config = ''
          require('copilot').setup({
            suggestion = { enabled = false },
            panep = { enabled = false },
          })
        '';
      }

      {
        plugin = telescope-nvim;
        type = "lua";
        config = /* lua */ ''
          require('telescope').setup({})
          require('telescope').load_extension('fzf')
          local tb = require('telescope.builtin')
          vim.keymap.set('n', '<leader>ff', tb.find_files, {})
          vim.keymap.set('n', '<leader>fg', tb.live_grep, {})
          vim.keymap.set('n', '<leader>fb', tb.buffers, {})
          vim.keymap.set('n', '<leader>fh', tb.help_tags, {})
          vim.keymap.set('n', '<leader>fo', tb.vim_options, {})
          vim.keymap.set('n', '<leader>fs', tb.lsp_document_symbols, {})
        '';
      }
      telescope-fzf-native-nvim
      neorg-telescope

      cmp_luasnip
      cmp-nvim-lsp
      cmp-buffer
      cmp-path
      cmp-nvim-lua
      {
        plugin = copilot-cmp;
        type = "lua";
        config = ''
          require('copilot_cmp').setup({})
        '';
      }
      {
        plugin = nvim-cmp;
        type = "lua";
        config = /* lua */ ''
          local cmp = require('cmp')
          cmp.setup({
            snippet = {
              expand = function(args)
                require('luasnip').lsp_expand(args.body)
              end,
            },

            window = {
              completion = cmp.config.window.bordered(),
              documentation = cmp.config.window.bordered(),
            },

            mapping = cmp.mapping.preset.insert({
              ['<C-b>'] = cmp.mapping.scroll_docs(-4),
              ['<C-f>'] = cmp.mapping.scroll_docs(4),
              ['<C-Space>'] = cmp.mapping.complete(),
              ['<C-e>'] = cmp.mapping.abort(),
              ['<CR>'] = cmp.mapping.confirm({ select = true }),
            }),

            sources = cmp.config.sources({
              { name = "luasnip"},
              { name = "buffer"},
              { name = "path"},
              { name = "nvim_lua"},
              { name = "nvim_lsp"},
              { name = "copilot"},
            }),
          })
        '';
      }

      luasnip
      {
        plugin = dashboard-nvim;
        type = "lua";
        config = ''
          require("dashboard").setup()
        '';
      }

      {
        plugin = gitsigns-nvim;
        type = "lua";
        config = ''
          require('gitsigns').setup({
            numhl = true,
            current_line_blame = true,
          })
        '';
      }
      indent-blankline-nvim
      lualine-nvim
      neo-tree-nvim
      bufferline-nvim
      neorg
      nvim-autopairs
      nvim-surround
      comment-nvim
      bufferline-nvim
      popup-nvim
      diffview-nvim

      {
        plugin = which-key-nvim;
        type = "lua";
        config = /* lua */ ''
          vim.o.timeout = true
          vim.o.timeoutlen = 300
          require("which-key").setup({})
        '';
      }
    ];
    
    extraLuaConfig = /* lua */ ''
      if vim.g.vscode then
        return
      else
        vim.cmd([[ colorscheme gruvbox ]])
        vim.g.mapleader = " "
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
      end
    '';
  };
}
