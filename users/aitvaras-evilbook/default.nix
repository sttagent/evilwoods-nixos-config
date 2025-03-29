{
  evilib,
  pkgs,
  ...
}:
let
  inherit (evilib) mkImportList;
  inherit (evilib.readInVarFile ../aitvaras/vars.toml) currentUser;
  # inherit (options.evilwoods.vars) shell;
in
{
  imports = [ ../aitvaras ] ++ (mkImportList ./.);

  home-manager.users.${currentUser} = {

    programs = {
      home-manager.enable = true;

      ghostty = {
        enable = true;
        settings = {
          font-family = "CommitMono Nerd Font Mono";
          theme = "GruvboxDarkHard";
          window-theme = "ghostty";
          command = "fish";
          window-save-state = "always";
          window-padding-x = 2;
          adw-toolbar-style = "flat";
          shell-integration = "none";
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
            merge-editor = "meld";
            default-command = [
              "status"
            ];
            paginate = "never";
            diff.tool = [
              "difft"
              "--color=always"
              "$left"
              "$right"
            ];
          };
        };
      };

      firefox = {
        enable = true;
        nativeMessagingHosts = [ pkgs.tridactyl-native ];
        profiles."${currentUser}" = {
          name = "${currentUser}";
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
                urls = [ { template = "https://wiki.nixos.org/w/index.php?search={searchTerms}"; } ];
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
      # zed = {
      #   source = dotFilesPath + "/zed";
      #   recursive = true;
      # };
    };
  };
}
