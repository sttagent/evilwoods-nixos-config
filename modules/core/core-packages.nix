{ config, pkgs, lib, ... }:

{
  config = {
    environment.systemPackages = with pkgs; [
      neovim
      zellij
      wget
      git
      git-crypt
      htop
      gnupg
    ];
  };
}
