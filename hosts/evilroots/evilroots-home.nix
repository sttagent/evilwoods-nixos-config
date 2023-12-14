{ config, lib, pkgs, inputs, ... }: # os configuration is reachable via nixosConfig
let
  primaryUser = config.evilcfg.primaryUser;
  hmlib = inputs.home-manager.lib;
in
{
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "bak";
    users.${primaryUser} = {
      home = {
        username = "${primaryUser}";
        homeDirectory = "/home/${primaryUser}";

        stateVersion = "24.05";

        file = {
          ".config/background" = {
            source = ../../resources/wallpapers/background1.jpg;
          };
        };
      };

      dconf.settings = with hmlib.hm.gvariant; {
        "system/locale" = {
          region = "sv_SE.UTF-8";
        };

        "com/raggesilver/BlackBox" = {
          floating-controls = true;
          floating-controls-hover-area = mkUint32 10;
          remember-window-size = true;
          show-headerbar = false;
          terminal-padding = mkTuple [ (mkUint32 10) (mkUint32 10) (mkUint32 10) (mkUint32 10) ];
        };

        "org/gnome/desktop/background" = {
          picture-uri = "file:///home/${primaryUser}/.config/background";
          picture-uri-dark = "file:///home/${primaryUser}/.config/background";
          picture-options = "zoom";
        };

        "org/gnome/desktop/screensaver" = {
          picture-uri = "file:///home/${primaryUser}/.config/background";
        };

        "org/gnome/desktop/interface" = {
          color-scheme = "prefer-dark";
          gtk-theme = "Adwaita-dark";
          monospace-font-name = "SauceCodePro Nerd Font 10";
        };

        "org/gnome/desktop/session" = {
          idle-delay = mkUint32 900;
        };

        "org/gnome/desktop/input-sources" = {
          sources = [ (mkTuple [ "xkb" "us" ]) (mkTuple [ "xkb" "se" ]) ];
        };

        "org/gnome/settings-daemon/plugins/power" = {
          sleep-inactive-ac-type = "nothing";
        };

        "org/gnome/mutter" = {
          dynamic-workspaces = true;
          edge-tiling = true;
          workspaces-only-on-primary = true;
        };

        "org/gnome/shell" = {
          favorite-apps = [
            "firefox.desktop"
            "org.gnome.Nautilus.desktop"
            "com.raggesilver.BlackBox.desktop"
            "Alacritty.desktop"
            "io.gitlab.news_flash.NewsFlash.desktop"
            "org.gnome.Fractal.desktop"
            "com.valvesoftware.Steam.desktop"
            "discord.desktop"
            "com.yubico.authenticator.desktop"
            "code.desktop"
            "com.mattjakeman.ExtensionManager.desktop"
            "com.github.tchx84.Flatseal.desktop"
            "net.nokyan.Resources.desktop"
            "org.gnome.Settings.desktop"
          ];
        };

        "org/gnome/nautilus/icon-view" = {
          default-zoom-level = "small-plus";
        };
      };

      programs = {
        home-manager.enable = true;

        direnv = {
          enable = true;
          nix-direnv.enable = true;
        };

        git = {
          enable = true;
          userName = "Arvydas Ramanauskas";
          userEmail = "arvydas.ramanauskas@evilwoods.net";
        };

        fish = {
          enable = true;
          functions = {
            fish_user_key_bindings = {
              body = ''
                fish_default_key_bindings -M insert
                fish_vi_key_bindings --no-erase insert
              '';
            };
          };
          shellInit = ''
            set -U fish_greeting
            fish_user_key_bindings
            set fish_cursor_default block
            set fish_cursor_insert line
            set fish_cursor_replace_one underscore
            set fish_cursor_visual block
            set -x ZELLIJ_AUTO_ATTACH true
            # set -x ZELLIJ_AUTO_EXIT true
          '';
        };

        zellij = {
          enable = true;
          # ableFishIntegration = true;
          settings = {
            copy_command = "wl-copy";
            mirror_session = true;
            theme = "gruvbox-dark";
            themes = {
              gruvbox-light = {
                fg = [ 124 111 100 ];
                bg = [ 251 82 75 ];
                black = [ 40 40 40 ];
                red = [ 205 75 69 ];
                green = [ 152 151 26 ];
                yellow = [ 215 153 33 ];
                blue = [ 69 133 136 ];
                magenta = [ 177 98 134 ];
                cyan = [ 104 157 106 ];
                white = [ 213 196 161 ];
                orange = [ 214 93 14 ];
              };
              gruvbox-dark = {
                fg = [ 213 196 161 ];
                bg = [ 40 40 40 ];
                black = [ 60 56 54 ];
                red = [ 204 36 29 ];
                green = [ 152 151 26 ];
                yellow = [ 215 153 33 ];
                blue = [ 69 133 136 ];
                magenta = [ 177 98 134 ];
                cyan = [ 104 157 106 ];
                white = [ 251 241 199 ];
                orange = [ 214 93 14 ];
              };
            };
          };
        };

        alacritty = {
          enable = true;
          settings = {
            window = {
              startup_mode = "Maximized";
              opacity = 0.99;
              blur = true;
            };
            colors = {
              # Default colors
              primary = {
                background = "0x24292e";
                foreground = "0xd1d5da";
              };

              # Normal colors
              normal = {
                black = "0x586069";
                red = "0xea4a5a";
                green = "0x34d058";
                yellow = "0xffea7f";
                blue = "0x2188ff";
                magenta = "0xb392f0";
                cyan = "0x39c5cf";
                white = "0xd1d5da";
              };

              # Bright colors
              bright = {
                black = "0x959da5";
                red = "0xf97583";
                green = "0x85e89d";
                yellow = "0xffea7f";
                blue = "0x79b8ff";
                magenta = "0xb392f0";
                cyan = "0x56d4dd";
                white = "0xfafbfc";
              };

              indexed_colors = [
                { index = 16; color = "0xd18616"; }
                { index = 17; color = "0xf97583"; }
              ];
            };
          };
        };

        atuin = {
          enable = true;
          enableFishIntegration = true;
        };

        starship = {
          enable = true;
          enableFishIntegration = true;
        };

        zoxide = {
          enable = true;
          enableFishIntegration = true;
        };

        eza = {
          enable = true;
          enableAliases = true;
          icons = true;
        };

        nix-index = {
          enable = true;
          enableFishIntegration = true;
        };
        
        vscode = {
          enable = true;
          extensions = with pkgs.vscode-extensions; [
            eamodio.gitlens
            ms-vscode-remote.remote-containers
            ms-vscode-remote.remote-ssh
            asvetliakov.vscode-neovim
            github.copilot
            github.copilot-chat
            ms-python.python
            ms-python.vscode-pylance
            esbenp.prettier-vscode
            ms-azuretools.vscode-docker
            tailscale.vscode-tailscale
            jnoortheen.nix-ide
            arrterian.nix-env-selector
            jdinhlife.gruvbox
            redhat.vscode-yaml
            ms-vsliveshare.vsliveshare
            mkhl.direnv
            github.vscode-github-actions
            github.vscode-pull-request-github
            sumneko.lua
          ];
          
          userSettings = {
            "extensions.experimental.affinity" = {
              "asvetliakov.vscode-neovim" = 1;
            };
            "files.autoSave" = "afterDelay";
            "window.titleBarStyle" = "custom";
            "workbench.colorTheme" = "Gruvbox Dark Hard";
            "git.confirmSync" = false; 
          };
        };
        
        firefox = {
          enable = true;
          profiles."${primaryUser}" = {
            name = "${primaryUser}";
            search.default = "DuckDuckGo";
            settings =  {
              "browser.contentblocking.category" = "strict";
              "gfx.webrender.all" = true;
              "media.ffmpeg.vaapi.enabled" = true;
              "widget.dmabuf.force-enabled" = true;
            };
          };
        };

        neovim = {
          enable = true;
          defaultEditor = true;

          viAlias = true;
          vimAlias = true;
          vimdiffAlias = true;

          plugins = with pkgs.vimPlugins; [
            nvim-web-devicons
            plenary-nvim
            gruvbox-nvim

            {
              plugin = nvim-treesitter.withAllGrammars;
              type = "lua";
              config = ''
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
            lsp-zero-nvim

            {
              plugin = copilot-lua;
              type = "lua";
              config = ''
                require('copilot').setup({})
              '';
            }

            {
              plugin = telescope-nvim;
              type = "lua";
              config = ''
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

            copilot-cmp
            cmp_luasnip
            cmp-nvim-lsp
            cmp-buffer
            cmp-path
            cmp-nvim-lua
            {
              plugin = nvim-cmp;
              type = "lua";
              config = ''
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
                    { name = "copilot_cmp"},
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
              config = ''
                vim.o.timeout = true
                vim.o.timeoutlen = 300
                require("which-key").setup({})
              '';
            }
          ];

          extraPackages = with pkgs; [
            lua-language-server
            yaml-language-server
            pylyzer
            ansible-language-server
            nodejs_21
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
      };
    };
  };
}
