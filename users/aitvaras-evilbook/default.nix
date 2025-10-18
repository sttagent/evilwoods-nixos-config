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
          theme = "Miasma";
          window-theme = "ghostty";
          window-save-state = "always";
          window-padding-x = 2;
          adw-toolbar-style = "flat";
          shell-integration = "true";
          command = "fish";
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
            diff-formater = [
              "difft"
              "--color=always"
              "$left"
              "$right"
            ];
          };
        };
      };

    };
    xdg = {
      autostart = {
        enable = true;
        entries = [
          "${pkgs.filen-desktop}/share/applications/filen-desktop.desktop"
        ];
      };
      configFile = {
        # zed = {
        #   source = dotFilesPath + "/zed";
        #   recursive = true;
        # };
      };

    };

  };
}
