{
  self,
  inputs,
  ...
}:
{
  flake.modules.nixos."userRyne@rynepc" =
    { pkgs, ... }:
    let
      currentUser = "ryne";
    in
    {
      imports = [ self.modules.nixos.userRyne ];

      users.users.${currentUser}.uid = 1001;

      home-manager = {
        sharedModules = [
          inputs.sops-nix.homeManagerModules.sops
        ];

        users.${currentUser} = {

          programs = {
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

          };
          xdg = {
            autostart = {
              enable = true;
              entries = [
                "${pkgs.filen-desktop}/share/applications/filen-desktop.desktop"
              ];
            };
            configFile = { };
          };
        };
      };
    };
}
