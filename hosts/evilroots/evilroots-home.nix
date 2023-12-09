{ config, lib, pkgs, inputs, ... }: # os configuration is reachable via nixosConfig
let
  primaryUser = config.evilcfg.primaryUser;
  hmlib = inputs.home-manager.lib;
in
{
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
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

      dconf.settings = with hmlib.hm.gvariant;{
        "com/raggesilver/BlackBox" = {
          remember-window-size = true;

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
            "com.valvesoftware.Steam.desktop"
            "discord.desktop"
            "com.yubico.authenticator.desktop"
            "code.desktop"
            "com.mattjakeman.ExtensionManager.desktop"
            "com.github.tchx84.Flatseal.desktop"
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
            set -x ZELLIJ_AUTO_EXIT true
            # set -x ZELLIJ_SESSION_NAME evilroots-main
          '';
        };

        zellij = {
          enable = true;
          enableFishIntegration = true;
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
              opacity = 0.95;
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

        neovim = {
          enable = true;
          defaultEditor = true;

          viAlias = true;
          vimAlias = true;
          vimdiffAlias = true;

          plugins = with pkgs.vimPlugins; [
            nvim-web-devicons
            plenary-nvim
            nvim-lspconfig
            lsp-zero-nvim
            nvim-treesitter.withAllGrammars
            nvim-treesitter-textobjects
            nvim-treesitter-context
            gruvbox-nvim
            copilot-lua
            telescope-nvim
            telescope-fzf-native-nvim
            neorg-telescope

            copilot-cmp
            nvim-cmp
            cmp_luasnip
            cmp-nvim-lsp
            cmp-buffer
            cmp-path
            cmp-nvim-lua

            luasnip
            dashboard-nvim
            gitsigns-nvim
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
          ];

          extraPackages = with pkgs; [
            lua-language-server
            yaml-language-server
            pylyzer
            ansible-language-server
          ];
          
          extraLuaConfig = /* lua */ ''
            if vim.g.vscode then
              return
            else
            end
          '';
        };
      };
    };
  };
}
