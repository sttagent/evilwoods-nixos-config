{ config, lib, pkgs, inputs, ... }: # os configuration is reachable via nixosConfig
let
  mainUser = config.evilwoods.mainUser;
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

            extraPackages = with pkgs; [
              gnumake
              gcc
              lua-language-server
              yaml-language-server
              pylyzer
              ansible-language-server
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
  };
}
