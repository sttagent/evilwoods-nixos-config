{ pkgs, inputs, ... }:
let
  inherit (import ../aitvaras/vars.nix) thisUser;
  hmlib = inputs.home-manager.lib;
  hmlibgv = hmlib.hm.gvariant;
  resourceDir = inputs.self.outPath + "/resources";
  configDir = inputs.self.outPath + "/configfiles";
in
{
  imports = [ ../aitvaras ];

  users.users.${thisUser}.extraGroups = [ "libvirtd" ];

  home-manager.users.${thisUser} = {
    home = {
      file = {
        ".config/background" = {
          source = resourceDir + "/wallpapers/background2.jpg";
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

      "org/gtk/gtk4/settings/file-chooser" = {
        show-hidden = true;
      };

      "com/raggesilver/BlackBox" = {
        floating-controls = true;
        floating-controls-hover-area = hmlibgv.mkUint32 10;
        remember-window-size = true;
        show-headerbar = false;
        terminal-padding =
          with hmlibgv;
          mkTuple [
            (mkUint32 10)
            (mkUint32 10)
            (mkUint32 10)
            (mkUint32 10)
          ];
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
          "vivaldi-stable.desktop"
          "thunderbird.desktop"
          "org.gnome.Nautilus.desktop"
          "kitty.desktop"
          "dev.zed.Zed.desktop"
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

      kitty = {
        enable = true;
        shellIntegration = {
          enableFishIntegration = true;
        };
        themeFile = "GruvboxMaterialDarkHard";
        settings = {
          font_family = "Commit Mono Nerd Font";
          wayland_titlebar_color = "background";
        };
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
          search = {
            engines = {
              "Nix Packages" = {
                urls = [
                  {
                    template = "https://search.nixos.org/packages";
                    params = [
                      {
                        name = "channel";
                        value = "unstable";
                      }
                      {
                        name = "type";
                        value = "packages";
                      }
                      {
                        name = "query";
                        value = "{searchTerms}";
                      }
                    ];
                  }
                ];
                icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
                definedAliases = [ "@np" ];
              };

              "Nix Options" = {
                urls = [
                  {
                    template = "https://search.nixos.org/options";
                    params = [
                      {
                        name = "channel";
                        value = "unstable";
                      }
                      {
                        name = "type";
                        value = "packages";
                      }
                      {
                        name = "query";
                        value = "{searchTerms}";
                      }
                    ];
                  }
                ];
                icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
                definedAliases = [ "@no" ];
              };

              "NixOS Wiki" = {
                urls = [ { template = "https://wiki.nixos.org/index.php?search={searchTerms}"; } ];
                iconUpdateURL = "https://wiki.nixos.org/favicon.png";
                updateInterval = 24 * 60 * 60 * 1000; # every day
                definedAliases = [ "@nw" ];
              };

              "Bing".metaData.hidden = true;
              "Google".metaData.alias = "@g"; # builtin engines only support specifying one additional alias
            };
            force = true;
          };
          settings = {
            "browser.contentblocking.category" = "strict";
            "gfx.webrender.all" = true;
            "media.ffmpeg.vaapi.enabled" = true;
            "widget.dmabuf.force-enabled" = true;
          };
        };
      };

    };
  };
}
