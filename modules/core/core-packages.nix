{ config, pkgs, lib, ... }:

{
  environment.systemPackages = with pkgs; [
    neovim
    wget
    git
    git-crypt
    htop
    gnupg
    tmux
  ];
}
