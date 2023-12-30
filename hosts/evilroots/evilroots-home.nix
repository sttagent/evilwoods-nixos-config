{ config, lib, pkgs, inputs, ... }: # os configuration is reachable via nixosConfig
let
  mainUser = config.evilcfg.mainUser;
  hmlib = inputs.home-manager.lib;
  resourceDir = inputs.self.outPath + "/resources";
in
{
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "bak";
    users.${mainUser} = {
      home = {
        username = "${mainUser}";
        homeDirectory = "/home/${mainUser}";

        stateVersion = "24.05";

        file = {
          ".config/background" = {
            source = resourceDir + "/wallpapers/background1.jpg";
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
          picture-uri = "file:///home/${mainUser}/.config/background";
          picture-uri-dark = "file:///home/${mainUser}/.config/background";
          picture-options = "zoom";
        };

        "org/gnome/desktop/screensaver" = {
          picture-uri = "file:///home/${mainUser}/.config/background";
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
            # "com.raggesilver.BlackBox.desktop"
            "kitty.desktop"
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

          enabled-extentions = [
            "valent@andyholmes.ca"
            "blur-my-shell@aunetx"
            "appindicatorsupport@rgcjonas.gmail.com"
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

        kitty = {
          enable = true;
          shellIntegration.enableFishIntegration = true;
          theme = "Gruvbox Material Dark Hard";
          settings = {
            wayland_titlebar_color = "background";
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
          enable = false;
          extensions = with pkgs.vscode-extensions; [
            eamodio.gitlens
            ms-vscode-remote.remote-containers
            ms-vscode-remote.remote-ssh
            asvetliakov.vscode-neovim
            # github.copilot
            # github.copilot-chat
            ms-python.python
            ms-python.vscode-pylance
            esbenp.prettier-vscode
            ms-azuretools.vscode-docker
            tailscale.vscode-tailscale
            jnoortheen.nix-ide
            arrterian.nix-env-selector
            redhat.vscode-yaml
            ms-vsliveshare.vsliveshare
            mkhl.direnv
            github.vscode-github-actions
            github.vscode-pull-request-github
            sumneko.lua
          ];

          userSettings = {
            "cody.commandCodeLenses" = true;
            "cody.autocomplete.formatOnAccept" = true;
            "editor.inlineSuggest.suppressSuggestions" = true;
            "extensions.experimental.affinity" = {
              "asvetliakov.vscode-neovim" = 1;
            };
            "files.autoSave" = "afterDelay";
            "git.confirmSync" = false;
            "window.titleBarStyle" = "custom";
            "workbench.colorTheme" = "Gruvbox Material Dark";
            "gruvboxMaterial.lightContrast" = "hard";
            "gruvboxMaterial.darkContrast" = "hard";
            "nix.enableLanguageServer" = true;
            "nix.serverPath" = "nixd";
            "[nix]"."editor.tabSize" = 2;
          };
        };

        firefox = {
          enable = true;
          profiles."${mainUser}" = {
            name = "${mainUser}";
            search = {
              force = true;
              default = "DuckDuckGo";
            };
            settings = {
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

          extraPackages = with pkgs; [
            gnumake
            gcc
            lua-language-server
            yaml-language-server
            pylyzer
            ansible-language-server
            nodejs_21
            nixd
          ];
        };
      };

      /* xdg.configFile = {
        nvim = {
          source = ../../dotconfig/nvim;
          recursive = true;
        };
      }; */
    };
  };
}
