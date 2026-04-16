{ inputs, ... }:
{
  flake.modules.nixos.hostEvilbook =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      programs.firefox.enable = lib.mkForce false;
      environment.systemPackages = with pkgs; [

        # prismlauncher pulls three java versions by default.
        # With this override, I pull just the one I need for GTNH.
        (prismlauncher.override {
          jdks = [
            pkgs.jdk25
            pkgs.jdk17
          ];
        })

        # Vivaldi does not follow gnomes dark mode setting.
        # This config helps with websites and dark mode, but
        # Vivaldi is still not working with dark mode.
        vivaldi
        vivaldi-ffmpeg-codecs

        element-desktop
        ffmpeg-full
        appimage-run
        distrobox
        yubioath-flutter
        wl-clipboard
        discord
        zed-editor
        gh
        obsidian
        ghostty
        qbittorrent
        opencode
        proton-vpn

        inputs.niks3.packages."x86_64-linux".niks3
      ];
    };
}
