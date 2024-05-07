{ pkgs, inputs, ... }: # os configuration is reachable via nixosConfig
let
  thisUser = "aitvaras";
  hmlib = inputs.home-manager.lib;
  hmlibgv = hmlib.hm.gvariant;
  resourceDir = inputs.self.outPath + "/resources";
  configDir = inputs.self.outPath + "/configfiles";
in
{
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "bak";
    users.${thisUser} = {
      home = {
        username = "${thisUser}";
        homeDirectory = "/home/${thisUser}";

        stateVersion = "24.05";

        file = {
          ".config/background" = {
            source = resourceDir + "/wallpapers/background1.jpg";
          };
          ".config/monitors.xml" = {
            source = configDir + "/monitors.xml";
          };
        };
      };

      dconf.settings = {
        "system/locale" = {
          region = "sv_SE.UTF-8";
        };

        "com/raggesilver/BlackBox" = {
          floating-controls = true;
          floating-controls-hover-area = hmlibgv.mkUint32 10;
          remember-window-size = true;
          show-headerbar = false;
          terminal-padding = with hmlibgv; mkTuple [ (mkUint32 10) (mkUint32 10) (mkUint32 10) (mkUint32 10) ];
        };

        "org/gnome/desktop/background" = {
          picture-uri = "file:///home/${thisUser}/.config/background";
          picture-uri-dark = "file:///home/${thisUser}/.config/background";
          picture-options = "zoom";
        };

        "org/gnome/desktop/screensaver" = {
          picture-uri = "file:///home/${thisUser}/.config/background";
        };

        "org/gnome/desktop/interface" = {
          color-scheme = "prefer-dark";
          gtk-theme = "Adwaita-dark";
          monospace-font-name = "SauceCodePro Nerd Font 10";
        };

        "org/gnome/desktop/session" = {
          idle-delay = hmlibgv.mkUint32 900;
        };

        "org/gnome/desktop/input-sources" = {
          sources = with hmlibgv; [ (mkTuple [ "xkb" "us" ]) (mkTuple [ "xkb" "se" ]) ];
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
            "standard-notes.desktop"
            "obsidian.desktop"
            "org.gnome.Fractal.desktop"
            "com.valvesoftware.Steam.desktop"
            "discord.desktop"
            "com.yubico.authenticator.desktop"
            "android-studio.desktop"
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

        helix = {
          enable = true;
          defaultEditor = true;
          settings = {
            theme = "gruvbox_dark_hard";
            editor = {
              cursorline = true;
              bufferline = "multiple";
              auto-save = true;
              rulers = [ 120 ];
              color-modes = true;
              whitespace = {
                render = "all";
              };
              indent-guides = {
                render = true;
              };
              line-number = "relative";
              lsp = {
                display-messages = true;
                display-inlay-hints = true;
              };

              cursor-shape = {
                insert = "bar";
                normal = "block";
                select = "block";
              };
            };
            keys.normal = {
              space.space = "file_picker";
              space.w = ":w";
              space.q = ":q";
              esc = [ "collapse_selection" "keep_primary_selection" ];
            };
          };
          languages = {
            language = [
              {
                name = "nix";
                indent = {
                  tab-width = 2;
                  unit = " ";
                };
                auto-format = true;
                roots = [ "flake.lock" ];
                formatter.command = "nixpkgs-fmt";
              }
            ];
          };
        };

        gh = {
          enable = true;
          extensions = with pkgs; [
            gh-copilot
          ];
          settings = {
            git_protocol = "ssh";
          };
        };

        direnv = {
          enable = true;
          nix-direnv.enable = true;
        };

        git = {
          enable = true;
          delta.enable = true;
          userName = "Arvydas Ramanauskas";
          userEmail = "711261+sttagent@users.noreply.github.com";
          extraConfig = {
            core = {
              autocrlf = "input";
            };
          };
        };

        jujutsu = {
          enable = true;
          settings = {
            user = {
              name = "Arvydas Ramanauskas";
              email = "aram@ewmail.me";
            };
          };
        };

        lazygit = {
          enable = true;
          settings = {
            git.paging.pager = "delta --dark --paging=never";
          };
        };
        nushell = {
          enable = true;
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
          shellIntegration = {
            enableFishIntegration = true;
          };
          theme = "Gruvbox Material Dark Hard";
          settings = {
            font_family = "Hack Nerd Font";
            wayland_titlebar_color = "background";
          };
        };


        atuin = {
          enable = true;
          enableFishIntegration = true;
          enableNushellIntegration = true;
        };

        starship = {
          enable = true;
          enableFishIntegration = true;
          enableNushellIntegration = true;
        };

        zoxide = {
          enable = true;
          enableFishIntegration = true;
          enableNushellIntegration = true;
        };

        eza = {
          enable = true;
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
            github.copilot
            github.copilot-chat
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
          profiles."${thisUser}" = {
            name = "${thisUser}";
            # search = {
            #   engines = {
            #     kagi = {
            #       name = "Kagi";
            #       shortName = "kagi";
            #       url = "https://kagi.com/search?q={searchTerms}";
            #     };
            #   };
            #   force = true;
            #   default = "Kagi";
            # };
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

          viAlias = true;
          vimAlias = true;
          vimdiffAlias = true;

          extraPackages = with pkgs; [
            gnumake
            gcc
            lua-language-server
            yaml-language-server
            # pylyzer
            ansible-language-server
            nixd
            nodejs_22
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
