{
  inputs,
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib)
    mkIf
    mkForce
    ;
  inherit (config.evilwoods.desktop) desktopEnvironment;
in
{
  config = mkIf (desktopEnvironment == "niri") {
    boot.plymouth.enable = mkForce false;
    programs = {
      niri.enable = true;
      uwsm = {
        enable = true;
        waylandCompositors.niri = {
          binPath = "/run/current-system/sw/bin/niri";
          comment = "Niri (UWSM)";
          extraArgs = [ "--session" ];
          prettyName = "Niri";
        };
      };
    };
    environment.systemPackages = with pkgs; [
      xwayland-satellite
      inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default
      fuzzel
    ];
    services = {
      noctalia-shell.enable = true;
      tuned.enable = true;

      gnome.gnome-keyring.enable = true;

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
