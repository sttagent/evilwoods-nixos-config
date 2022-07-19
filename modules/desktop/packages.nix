
{config, pkgs, nixpkgs-unstable, lib, ...}:

let
  unstable = import nixpkgs-unstable {
    system = "x86_64-linux";
    config = { allowUnfree = true; };
  };

in {
  config = {
    environment.systemPackages = with pkgs; [
      neovim
      firefox-wayland
      wget
      tmux
      nushell
      git
      git-crypt
      htop
      gnupg
      ffmpeg-full
      gnome-feeds
      yubioath-desktop
      unstable.bottles
    ];

    environment.variables = {
      MOZ_ENABLE_WAYLAND = "1";
      EDITOR = "nvim";
    };

    environment.gnome.excludePackages = with pkgs; [
      epiphany
    ];
  };
}
