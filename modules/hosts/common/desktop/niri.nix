{
  self,
  inputs,
  ...
}:
{
  flake.modules.nixos.niri =
    {
      lib,
      config,
      pkgs,
      ...
    }:
    let
      inherit (lib)
        mkForce
        ;
      inherit (pkgs.stdenv.hostPlatform) system;
    in
    {
      imports = [
        self.modules.nixos.desktop
        inputs.noctalia.nixosModules.default
      ];

      evilwoods = {
        flags.isDesktop = true;
        variables = {
          desktopEnvironment = "niri";
        };
      };

      boot.plymouth.enable = mkForce false;
      programs = {
        niri = {
          enable = true;
          useNautilus = true;
        };

        uwsm = {
          enable = true;
          waylandCompositors.niri = {
            binPath = "/run/current-system/sw/bin/niri";
            comment = "Niri (UWSM)";
            extraArgs = [ "--session" ];
            prettyName = "Niri";
          };
        };

        kdeconnect.enable = true;
      };

      environment.systemPackages = with pkgs; [
        xwayland-satellite
        # (inputs.noctalia.packages.${system}.default.override { calendarSupport = true; })
        nautilus
        adwaita-icon-theme
        adw-gtk3
        kdePackages.qttools
      ];

      fonts.packages = with pkgs; [
        adwaita-fonts
      ];

      security.polkit.enable = true;

      services = {
        noctalia-shell.enable = true;
        tuned.enable = true;
        udisks2.enable = true;

        gnome = {
          sushi.enable = true;
          gnome-keyring.enable = true;
          evolution-data-server.enable = true;
        };

        greetd = {
          enable = true;
          useTextGreeter = true;
          settings = {
            default_session =
              let
                sessions = "${config.services.displayManager.sessionData.desktops}/share/xsessions:${config.services.displayManager.sessionData.desktops}/share/wayland-sessions";
              in
              {
                command = "${pkgs.tuigreet}/bin/tuigreet --sessions ${sessions} --time --asterisks --remember --remember-user-session";
                user = "greeter";
              };
          };
        };
      };
    };
}
