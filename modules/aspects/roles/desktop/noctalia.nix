{ den, ... }: {
  den.aspects.roles.desktop.noctalia = {
    includes = [ den.aspects.roles.desktop ];
    nixos =
      {
        lib,
        pkgs,
        ...
      }:
      let
        inherit (lib)
          mkForce
          ;
      in
      {
        programs = {
          noctalia = {
            enable = true;
            systemd.enable = true;
            recommendedServices.enable = true;
          };

          kdeconnect.enable = true;
        };

        fonts.packages = with pkgs; [
          adwaita-fonts
        ];

        security.polkit.enable = true;

        services = {

          gnome = {
            sushi.enable = true;
            evolution-data-server.enable = true;
          };

          displayManager.noctalia-greeter = {
            enable = true;
          };
        };
      };
  };
}
