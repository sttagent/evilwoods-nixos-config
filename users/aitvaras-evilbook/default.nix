{
  evilib,
  pkgs,
  inputs,
  dotFilesPath,
  ...
}:
let
  inherit (evilib.readInVarFile ../aitvaras/vars.toml) thisUser;
  hmlib = inputs.home-manager.lib;
  hmlibgv = hmlib.hm.gvariant;
  resourceDir = inputs.self.outPath + "/resources";
  configDir = inputs.self.outPath + "/dotfiles";
in
{
  imports = [
    ../aitvaras
    ./hyprland.nix
  ];

  users.users.${thisUser}.extraGroups = [ "libvirtd" ];

  home-manager.users.${thisUser} = {
    home = {
      file = {
        ".config/background" = {
          source = resourceDir + "/wallpapers/background2.jpg";
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
        accent-color = "green";
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
          "org.gnome.Evolution.desktop"
          "thunderbird.desktop"
          "org.gnome.Nautilus.desktop"
          "com.mitchellh.ghostty.desktop"
          "kitty.desktop"
          "org.codeberg.dnkl.foot.desktop"
          "dev.zed.Zed.desktop"
          "io.gitlab.news_flash.NewsFlash.desktop"
          "standard-notes.desktop"
          "obsidian.desktop"
          "dev.geopjr.Tuba.desktop"
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

      ghostty = {
        enable = true;
        settings = {
          font-family = "CommitMono Nerd Font Mono";
          theme = "GruvboxDarkHard";
          window-theme = "ghostty";
          command = "xonsh";
          window-save-state = "always";
          window-padding-x = 2;
          adw-toolbar-style = "flat";
        };
      };

      kitty = {
        enable = false;

        shellIntegration = {
          enableFishIntegration = true;
        };
        themeFile = "GruvboxMaterialDarkHard";
        settings = {
          shell = "xonsh";
          font_family = "Commit Mono Nerd Font";
          wayland_titlebar_color = "background";
        };
      };
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
            space.l = [
              ":new"
              ":insert-output lazygit"
              ":buffer-close!"
              ":redraw"
            ];
            esc = [
              "collapse_selection"
              "keep_primary_selection"
            ];
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
        extensions = with pkgs; [ gh-copilot ];
        settings = {
          git_protocol = "ssh";
        };
      };

      jujutsu = {
        enable = true;
        settings = {
          user = {
            name = "Arvydas Ramanauskas";
            email = "711261+sttagent@users.noreply.github.com";
          };
          ui = {
            default-command = [
              "status"
              "--no-pager"
            ];
          };
        };
      };

      zed-editor = {
        enable = false;
        extensions = [
          "nix"
          "just"
          "lua"
          "toml"
          "python"
        ];
        userSettings = {
          theme = {
            mode = "system";
            light = "Gruvbox Light Hard";
            dark = "Gruvbox Dark Hard";
          };
          features = {
            inline_completion_provider = "supermaven";
          };
          assistant = {
            default_model = {
              provider = "zed.dev";
              model = "claude-3-5-sonnet-latest";
            };
            version = "2";
          };
          autosave = "on_focus_change";
          vim_mode = true;
          vim = {
            toggle_relative_line_numbers = true;
          };
          ui_font_size = 16;
          buffer_font_family = "CommitMono Nerd Font";
          buffer_font_size = 15;
          buffer_line_height = "standard";
          tabs = {
            file_icons = true;
            git_status = true;
          };
          languages = {
            Nix = {
              format_on_save = "on";
              tab_size = 2;
            };
          };
          terminal = {
            shell = "xonsh";
            line_height = "standard";
          };
        };
      };

      firefox = {
        enable = true;
        nativeMessagingHosts = [ pkgs.tridactyl-native ];
        profiles."${thisUser}" = {
          name = "${thisUser}";
          id = 0;
          isDefault = true;
          search = {
            force = true;
            default = "Evilwoods";
            order = [
              "Evilwoods"
              "Google"
            ];
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

              "Evilwoods" = {
                urls = [ { template = "https://search.evilwoods.net/search?q={searchTerms}"; } ];
                definedAliases = [ "@ew" ];
              };

              "Bing".metaData.hidden = true;
              "Google".metaData.alias = "@g"; # builtin engines only support specifying one additional alias
            };
          };
          settings = {
            "browser.startup.homepage" = "https://search.evilwoods.net/";
            "browser.search.defaultenginename" = "Evilwoods";
            "browser.contentblocking.category" = "strict";
            "gfx.webrender.all" = true;
            "media.ffmpeg.vaapi.enabled" = true;
            "widget.dmabuf.force-enabled" = true;
          };
        };
      };
    };

    xdg.configFile = {
      zed = {
        source = dotFilesPath + "/zed";
        recursive = true;
      };
    };
  };
}
