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
