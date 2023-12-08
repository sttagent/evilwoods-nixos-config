{ config, lib, pkgs, home-manager, ... }: # os configuration is reachable via nixosConfig
let
  primaryUser = config.evilcfg.primaryUser;
  hmlib = home-manager.lib;
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
            "io.gitlab.news_flash.NewsFlash.desktop"
            "discord.desktop"
            "com.yubico.authenticator.desktop"
            "code.desktop"
            "com.mattjakeman.ExtensionManager.desktop"
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
          shellInit = ''
            set -U fish_greeting
          '';
        };
        
        zellij = {
          enable = true;
          enableFishIntegration = true;
          settings = {
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

          viAlias = true;
          vimAlias = true;
          vimdiffAlias = true;
        };
      };
    };
  };
}
