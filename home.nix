{config, lib, pkgs, ...}: {
  home = {
    username = "aitvaras";
    homeDirectory = "/home/aitvaras";

    stateVersion = "24.05";
    
    file = {
      ".config/background" = {
        source = ./background1.jpg;
      };
    };
  };

  dconf.settings = with lib.hm.gvariant;{
    "com/raggesilver/BlackBox" = {
      remember-window-size = true;

    };
    
	  "org/gnome/desktop/background" = {
      picture-uri = "file:///home/aitvaras/.config/background";
      picture-uri-dark = "file:///home/aitvaras/.config/background";
      picture-options = "zoom";
    };

    "org/gnome/desktop/screensaver" = {
      picture-uri = "file:///home/aitvaras/.config/background";
    };

    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      gtk-theme = "Adwaita-dark";
    };

    "org/gnome/settings-daemon/plugins/power" = {
      sleep-inactive-ac-type = "nothing";
    };

    "org/gnome/desktop/input-sources" = {
      sources = [ (mkTuple [ "xkb" "us" ]) (mkTuple [ "xkb" "se" ]) ];
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
        "org.gnome.Settings.desktop"];
    };

    "org/gnome/nautilus/icon-view" = {
      default-zoom-level = "small-plus";
    };
  };
  
  systemd = {
    user = {
      mounts = {
        home-aitvaras-Games =  {
          Unit = {
            Description = "Mount games subvolume";
          };
          
          Mount =  {
            What = "/dev/disk/by-partlabel/disk-data-home";
            Type = "btrfs";
            Options = [ "subvol=games" "nodatacow"];
            Where = "/home/aitvaras/Games";
          };
          
          Install = {
            WantedBy = [ "default.target" ];
          };
        };
      };
    };
  };

  programs = {
    home-manager.enable = true;

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
  };
}
