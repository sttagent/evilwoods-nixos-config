{ inputs, ... }:
{
  flake.modules.nixos."userRyne" =
    { config, lib, ... }:
    let
      hmlib = inputs.home-manager.lib;
      hmlibgv = hmlib.hm.gvariant;
      currentUser = "ryne";
      inherit (config.evilwoods.variables) desktopEnvironment;
    in
    {
      config = lib.mkIf (desktopEnvironment == "gnome") {
        home-manager.users.${currentUser} = {
          dconf.settings = {
            "ca/andyholmes/valent" = {
              name = config.networking.hostName;
            };

            "system/locale" = {
              region = "sv_SE.UTF-8";
            };

            "org/gtk/gtk4/settings/file-chooser" = {
              show-hidden = true;
            };

            "org/gnome/desktop/interface" = {
              color-scheme = "prefer-dark";
              gtk-theme = "Adwaita-dark";
              monospace-font-name = "SauceCodePro Nerd Font 10";
              accent-color = "pink";
            };

            "org/gnome/desktop/session" = {
              idle-delay = hmlibgv.mkUint32 900;
            };

            "org/gnome/desktop/input-sources" = {
              sources = with hmlibgv; [
                (mkTuple [
                  "xkb"
                  "us"
                ])
                (mkTuple [
                  "xkb"
                  "se"
                ])
                (mkTuple [
                  "xkb"
                  "us+colemak_dh"
                ])
              ];
            };

            "org/gnome/settings-daemon/plugins/power" = {
              sleep-inactive-ac-type = "nothing";
            };

            "org/gnome/mutter" = {
              experimental-features = [
                "scale-monitor-framebuffer"
                "variable-refresh-rate"
              ];
              dynamic-workspaces = true;
              edge-tiling = true;
              workspaces-only-on-primary = true;
            };

            "org/gnome/shell/app-switcher" = {
              current-workspace-only = true;
            };

            "org/gnome/shell" = {
              favorite-apps = [
                "firefox.desktop"
                "org.gnome.Nautilus.desktop"
                "com.mitchellh.ghostty.desktop"
                "obsidian.desktop"
                "org.gnome.Fractal.desktop"
                "com.valvesoftware.Steam.desktop"
                "discord.desktop"
                "com.yubico.authenticator.desktop"
                "com.mattjakeman.ExtensionManager.desktop"
                "com.github.tchx84.Flatseal.desktop"
                "net.nokyan.Resources.desktop"
                "org.gnome.Settings.desktop"
              ];

              disable-user-extensions = false;
              enabled-extensions = [
                "valent@andyholmes.ca"
                "blur-my-shell@aunetx"
                "appindicatorsupport@rgcjonas.gmail.com"
              ];
            };

            "org/gnome/nautilus/icon-view" = {
              default-zoom-level = "small-plus";
            };
            "org/gnome/shell/extensions/blur-my-shell/panel" = {
              override-background-dynamically = true;
            };
          };
        };
      };
    };
}
