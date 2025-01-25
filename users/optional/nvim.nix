{
  config,
  evilib,
  pkgs,
  lib,
  inputs,
  ...
}:
let
  inherit (evilib.readInVarFile ./vars.toml) currentUser;

  nvimConfigDir = "../../dotfiles/nvim";
in
with builtins;
{
  home-manager.users.${currentUser}.programs.neovim = {
    extraLuaConfig = ''
      ${readFile ./${nvimConfigDir}/init.lua}
    '';

    plugins = with pkgs.vimPlugins; [
      nvim-web-devicons
      plenary-nvim
      gruvbox-material
      bufferline-nvim
      popup-nvim
      diffview-nvim
      trouble-nvim

      # Treesitter configuration
      {
        plugin = nvim-treesitter.withAllGrammars;
        type = "lua";
        config = ''
          ${readFile ./${nvimConfigDir}/addon-nvim-treesitter.lua}
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
          ${readFile ./${nvimConfigDir}/addon-lsp-zero-nvim.lua}
        '';
      }
      # End of nvim LSP configuration

      # Telescope configuration
      {
        plugin = telescope-nvim;
        type = "lua";
        config = ''
          ${readFile ./${nvimConfigDir}/addon-telescope-nvim.lua}
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
        plugin = nvim-cmp;
        type = "lua";
        config = ''
          ${readFile ./${nvimConfigDir}/addon-nvim-cmp.lua}
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
          ${readFile ./${nvimConfigDir}/addon-gitsigns-nvim.lua}
        '';
      }

      {
        plugin = indent-blankline-nvim;
        type = "lua";
        config = ''
          ${readFile ./${nvimConfigDir}/addon-indent-blankline-nvim.lua}
        '';
      }

      {
        plugin = lualine-nvim;
        type = "lua";
        config = ''
          require('lualine').setup({
            options = {
              theme = "gruvbox-material"
            };
          })
        '';
      }

      neo-tree-nvim

      {
        plugin = bufferline-nvim;
        type = "lua";
        config = ''
          ${readFile ./${nvimConfigDir}/addon-bufferline-nvim.lua}
        '';
      }

      neorg

      {
        plugin = nvim-autopairs;
        type = "lua";
        config = ''
          require('nvim-autopairs').setup({})
        '';
      }

      {
        plugin = nvim-surround;
        type = "lua";
        config = ''
          require('nvim-surround').setup({})
        '';
      }

      {
        plugin = comment-nvim;
        type = "lua";
        config = ''
          require('Comment').setup({})
        '';
      }

      {
        plugin = which-key-nvim;
        type = "lua";
        config = ''
          ${readFile ./${nvimConfigDir}/addon-which-key-nvim.lua}
        '';
      }

      # Nvim cofilot configuration
      {
        plugin = copilot-lua;
        type = "lua";
        config = ''
          ${readFile ./${nvimConfigDir}/addon-copilot-lua.lua}
        '';
      }
      {
        plugin = copilot-cmp;
        type = "lua";
        config = ''
          require('copilot_cmp').setup({})
        '';
      } # End nvim copilot configuration */
    ];
  };
}
