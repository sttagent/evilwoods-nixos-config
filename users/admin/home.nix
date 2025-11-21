{
  inputs,
  config,
  evilib,
  pkgs,
  dotFilesPath,
  ...
}: # os configuration is reachable via nixosConfig
let
  inherit (evilib.readInVarFile ./vars.toml) currentUser;
  inherit (config.evilwoods.vars) shell;
  secretsPath = toString inputs.evilsecrets;
in
{
  sops.secrets.aitvaras-password = {
    sopsFile = "${secretsPath}/secrets/common/deflault.yaml";
    neededForUsers = true;
  };

  users.users = {
    ${currentUser} = {
      isNormalUser = true;
      createHome = true;
      home = "/home/${currentUser}";
      description = "Adminitrator";
      hashedPasswordFile = config.sops.secrets.admin-password.path;
      extraGroups = [
        "wheel"
        "networkmanager"
      ]; # Enable ‘sudo’ for the user.
      shell = pkgs.fish;
    };

  };

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "bak";
    users.${currentUser} = {
      home = {
        username = "${currentUser}";
        homeDirectory = "/home/${currentUser}";

        stateVersion = config.system.stateVersion;
      };

      programs = {
        home-manager.enable = true;

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

        lazygit = {
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
            set fish_cursor_default block blink
            set fish_cursor_insert line blink
            set fish_cursor_replace_one underscore blink
            set fish_cursor_visual block blink
          '';
        };

        nushell = {
          enable = false;
          extraConfig = ''
            let fish_completer = {|spans|
                fish --command $'complete "--do-complete=($spans | str join " ")"'
                | from tsv --flexible --noheaders --no-infer
                | rename value description
            }
            $env.config = {
                completions: {
                    external: {
                        enable: true
                        completer: $fish_completer
                    }
                }
            }
          '';
        };

        zellij = {
          enable = false;
          settings = {
            default_mode = "locked";
            default_shell = shell;
            mirror_session = true;
            theme = "gruvbox-dark";
            attach_to_session = true;
          };
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
          source = dotFilesPath + "/zellij";
          recursive = true;
        };
        nvim = {
          source = dotFilesPath + "/lazynvim";
          recursive = true;
        };
        # xonsh = {
        #   source = dotFilesPath + "/xonsh";
        #   recursive = true;
        # };
      };
    };
  };
}
