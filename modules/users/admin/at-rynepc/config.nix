{
  den.aspects.admin.rynepc = {
    homeManager =
      { config, ... }:
      {
        programs = {
          home-manager.enable = true;

          ghostty = {
            enable = true;
            settings = {
              font-family = "CommitMono Nerd Font Mono";
              theme = "Miasma";
              window-theme = "ghostty";
              window-padding-x = 2;
              adw-toolbar-style = "flat";
              shell-integration = "fish";
              command = "fish";
            };
          };

          gh = {
            enable = true;
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
          configFile = { };
        };

      };
  };
}
