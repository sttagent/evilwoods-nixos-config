currentUser:
{ ... }:
{
  home-manager.users.${currentUser} = {
    programs.zed-editor = {
      enable = true;
      extensions = [
        "fish"
        "nix"
        "just"
        "lua"
        "toml"
        "python"
      ];
      userSettings = {
        sticky_scroll.enabled = true;
        auto_signature_help = true;
        inlay_hints.enabled = true;
        diagnostics.inline.enabled = true;
        theme = {
          mode = "system";
          light = "Gruvbox Light Hard";
          dark = "Gruvbox Dark Hard";
        };
        features = {
          edit_prediction_provider = "supermaven";
        };
        agent = {
          default_model = {
            provider = "zed.dev";
            model = "claude-4-sonnet";
          };
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
            formatter = {
              external = {
                command = "nixfmt";
                arguments = [ "--quiet" ];
              };
            };
          };
        };
        terminal = {
          line_height = "standard";
          shell = {
            program = "fish";
          };
        };
      };
    };
  };

}
