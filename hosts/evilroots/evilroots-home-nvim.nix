{ config, pkgs, lib, ...}: 
let
    primaryUser = config.evilcfg.primaryUser;
    nvimConfigDir = ../../configfiles/nvim;
in with builtins; {
  home-manager.users.${primaryUser}.programs.neovim = {
    plugins = with pkgs.vimPlugins; [
      nvim-web-devicons
      plenary-nvim
      gruvbox-nvim

      { # Treesitter configuration
        plugin = nvim-treesitter.withAllGrammars;
        type = "lua";
        config = ''
            ${readFile /${nvimConfigDir}/addon-nvim-treesitter.lua}
        '';
      }
      nvim-treesitter-textobjects
      nvim-treesitter-context
      # End of treesitter configuration

      # Nvim LSP configuration
      nvim-lspconfig
      {
        plugin = lsp-zero-nvim;
        type = "lua";
        config = ''
          ${readFile /${nvimConfigDir}/addon-lsp-zero-nvim.lua}
        '';
      } # End of nvim LSP configuration

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

      { # Telescope configuration
        plugin = telescope-nvim;
        type = "lua";
        config = ''
          ${readFile /${nvimConfigDir}/addon-telescope-nvim.lua}
        '';
      }
      telescope-fzf-native-nvim
      neorg-telescope
      # End of telescope configuration

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

      {
        plugin = indent-blankline-nvim;
        type = "lua";
        config = /* lua */ ''
            vim.opt.list = true
            vim.opt.listchars:append "space:⋅"
            vim.opt.listchars:append "eol:↴"
            require('ibl').setup({
                exclude = {
                    filetypes = {
                        'dashboard',
                    },
		},
            })
        '';
      }

      lualine-nvim
      neo-tree-nvim
      {
        plugin = bufferline-nvim;
        type = "lua";
        config = /* lua */ ''
            require('bufferline').setup({
                options = {
                    offsets = { {filetype = "NvimTree", text = "File Explorer", text_align = "center" } },
                }
            })
        '';
      }
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
        ${builtins.readFile /${nvimConfigDir}/init.lua}
    '';
  };
}
