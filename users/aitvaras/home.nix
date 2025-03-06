{
  config,
  evilib,
  pkgs,
  dotFilesPath,
  ...
}: # os configuration is reachable via nixosConfig
let
  inherit (evilib.readInVarFile ./vars.toml) currentUser;
  inherit (config.evilwoods.vars) shell;
in
{
  sops.secrets.aitvaras-password.neededForUsers = true;

  users.users = {
    ${currentUser} = {
      isNormalUser = true;
      createHome = true;
      home = "/home/${currentUser}";
      description = "Arvydas Ramanauskas";
      hashedPasswordFile = config.sops.secrets.aitvaras-password.path;
      extraGroups = [
        "wheel"
        "networkmanager"
      ]; # Enable ‘sudo’ for the user.
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
          enable = true;
          nix-direnv.enable = true;
        };

        git = {
          enable = true;
          # delta.enable = true;
          userName = "Arvydas Ramanauskas";
          userEmail = "711261+sttagent@users.noreply.github.com";
          extraConfig = {
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
            set -gx ZELLIJ_AUTO_ATTACH true
            # set -gx ZELLIJ_AUTO_EXIT true
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
          enableFishIntegration = true;
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
          enableFishIntegration = true;
          enableTransience = true;
        };

        zoxide = {
          enable = true;
          enableFishIntegration = true;
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
        xonsh = {
          source = dotFilesPath + "/xonsh";
          recursive = true;
        };
      };
    };
  };
}
