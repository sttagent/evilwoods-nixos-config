{ inputs, config, ... }:
let
  flake-config = config;
in
{
  flake.modules.nixos.userAitvaras =
    {
      pkgs,
      ...
    }:
    let
      currentUser = "aitvaras";
      dotFiles = inputs.self.outPath + "/dotfiles";
      nuConfig = dotFiles + "/nushell/config.nu";
    in
    {
      home-manager = {
        users.${currentUser} = {
          programs = {
            direnv = {
              config = {
                whitelist = {
                  exact = [
                    "/home/${currentUser}/Source/private/evilwoods-nixos-config"
                    "/home/${currentUser}/Source/private/evilwoods-nixos-config-secrets"
                  ];
                };
                warn_timeout = 0;
              };
              enable = true;
              nix-direnv.enable = true;
            };

            git = {
              enable = true;
              # delta.enable = true;
              settings = {
                user = {
                  name = "Arvydas Ramanauskas";
                  email = "711261+sttagent@users.noreply.github.com";
                };
                core = {
                  autocrlf = "input";
                };
              };
            };
            nushell = {
              enable = true;
              configFile.source = nuConfig;
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
                set fish_cursor_default block blink
                set fish_cursor_insert line blink
                set fish_cursor_replace_one underscore blink
                set fish_cursor_visual block blink
              '';
            };
            carapace = {
              enable = true;
            };

            atuin = {
              enable = true;
              settings = {
                sync.records = true;
                auto_sync = true;
                sync_frequency = "5m";
                sync_address = "http://evilcloud:8888";
                style = "full";
                inline_height = 0;
              };
            };

            starship = {
              enable = true;
              enableTransience = true;
            };

            zoxide = {
              enable = true;
            };

            eza = {
              enable = true;
              icons = "auto";
              extraOptions = [ "--group-directories-first" ];
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
                nodejs_22
              ];
            };

            broot = {
              enable = true;
              settings = {
                modal = true;
              };
            };
          };

          xdg.configFile = {
            zellij = {
              source = flake-config.paths.dotFilesPath + "/zellij";
              recursive = true;
            };
            nvim = {
              source = flake-config.paths.dotFilesPath + "/lazynvim";
              recursive = true;
            };
            # xonsh = {
            #   source = dotFilesPath + "/xonsh";
            #   recursive = true;
            # };
          };
        };
      };
    };
}
