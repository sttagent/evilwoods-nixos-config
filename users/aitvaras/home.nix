{ pkgs, inputs, ... }: # os configuration is reachable via nixosConfig
let
  inherit (import ./vars.nix) thisUser;
  hmlib = inputs.home-manager.lib;
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

      };


      programs = {
        home-manager.enable = true;

        helix = {
          enable = false;
          defaultEditor = false;
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
              space.l = [ ":new" ":insert-output lazygit" ":buffer-close!" ":redraw" ];
              esc = [ "collapse_selection" "keep_primary_selection" ];
            };
          };

          languages = {
            language-server.nixd = {
              command = "nixd";
            };
            language = [
              {
                name = "nix";
                indent = {
                  tab-width = 2;
                  unit = " ";
                };
                language-servers = [ "nixd" ];
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

        atuin = {
          enable = true;
          enableFishIntegration = true;
          enableNushellIntegration = true;
          settings = {
            sync.records = true;
            auto_sync = true;
            sync_frequency = "5m";
            sync_address = "http://evilserver:8888";
          };
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
            nodejs_22
          ];
        };
      };

      xdg.configFile = {
        nvim = {
          source = ../../configfiles/lazynvim;
          recursive = true;
        };
      };
    };
  };
}

