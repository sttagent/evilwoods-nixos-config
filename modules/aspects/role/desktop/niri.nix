{
  den.aspects.desktop-environment.niri = {
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
        boot.plymouth.enable = mkForce false;
        programs = {
          noctalia = {
            enable = true;
            systemd.enable = true;
            recommendedServices.enable = true;
          };
          niri = {
            enable = true;
            useNautilus = true;
          };

          uwsm = {
            enable = true;
            waylandCompositors.niri = {
              binPath = "/run/current-system/sw/bin/niri";
              comment = "Niri compositor managed by UWSM";
              extraArgs = [ "--session" ];
              prettyName = "Niri";
            };
          };

          kdeconnect.enable = false;
        };

        environment.systemPackages = with pkgs; [
          # noctalia-shell # old noctalia in nixpkgs
          xwayland-satellite
          adwaita-icon-theme
          adw-gtk3
          nautilus
        ];

        fonts.packages = with pkgs; [
          adwaita-fonts
        ];

        security.polkit.enable = true;

        services = {
          gnome.gnome-keyring.enable = false;
          oo7.enable = true;
          tuned.enable = true;
          udisks2.enable = true;
          gvfs.enable = true;

          gnome = {
            sushi.enable = true;
            evolution-data-server.enable = true;
          };

          displayManager.noctalia-greeter = {
            enable = true;
          };

          # greetd = {
          #   enable = true;
          #   useTextGreeter = true;
          #   settings = {
          #     default_session =
          #       let
          #         sessions = "${config.services.displayManager.sessionData.desktops}/share/xsessions:${config.services.displayManager.sessionData.desktops}/share/wayland-sessions";
          #       in
          #       {
          #         command = "${pkgs.tuigreet}/bin/tuigreet --sessions ${sessions} --time --asterisks --remember --remember-user-session";
          #         user = "greeter";
          #       };
          #   };
          # };
        };
      };
  };
}
