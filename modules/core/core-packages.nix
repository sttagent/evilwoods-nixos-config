{ config, pkgs, lib, ... }:

{
  config = {
    environment.systemPackages = with pkgs; [
      neovim
      lazygit
      zellij
      wget
      git
      git-crypt
      htop
      gnupg
    ];
  };
}
