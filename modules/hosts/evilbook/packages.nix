{ inputs, ... }:
{
  den.aspects.evilbook.nixos =
    {
      lib,
      pkgs,
      ...
    }:
    {
      programs = {
        xonsh.enable = true;
        direnv.enable = true;
        zoxide.enable = true;
        firefox.enable = lib.mkForce false;
      };

      environment.systemPackages = with pkgs; [

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
        codex

        # inputs.niks3.packages."x86_64-linux".niks3
      ];
    };
}
