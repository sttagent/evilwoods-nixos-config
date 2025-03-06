{ evilib, ... }:
let
  inherit (evilib.readInVarFile ../aitvaras/vars.toml) currentUser;
in
{
  home-manager.users.${currentUser} = {
    programs.zed-editor = {
      enable = true;
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
          edit_prediction_provider = "zed";
        };
        assistant = {
          default_model = {
            provider = "zed.dev";
            model = "claude-3-7-sonnet-latest";
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
            language_servers = [
              "nixd"
              "!nil"
            ];
            formater = {
              external = {
                command = "nixfmt";
                args = [ "--quiet" ];
              };
            };
          };
        };
        terminal = {
          shell = {
            program = "fish";
          };
          line_height = "standard";
        };
      };
    };
  };

}
