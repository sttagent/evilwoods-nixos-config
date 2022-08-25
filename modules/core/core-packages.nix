{ config, pkgs, lib, ... }:

{
  config = {
    environment.systemPackages = with pkgs; [
      neovim
      wget
      git
      git-crypt
      htop
      gnupg
      tmux
      fish
    ];
  };
}
