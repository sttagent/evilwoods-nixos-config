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
          ${readFile /${nvimConfigDir}/addon-copilot-lua.lua}
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

      # Nvim cmp configuration
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
        config = ''
          ${readFile /${nvimConfigDir}/addon-nvim-cmp.lua}
        '';
      } # End of nvim cmp configuration

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
          ${readFile /${nvimConfigDir}/addon-gitsigns-nvim.lua}
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
        config = ''
          ${readFile /${nvimConfigDir}/addon-bufferline-nvim.lua}
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
        config = ''
          ${readFile /${nvimConfigDir}/addon-which-key-nvim.lua}
        '';
      }
    ];
    
    extraLuaConfig = /* lua */ ''
        ${readFile /${nvimConfigDir}/init.lua}
    '';
  };
}
