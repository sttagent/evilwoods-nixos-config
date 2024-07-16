{ config, pkgs, ... }:
let
  cfg = config.evilwoods;
in
{
  config.environment.systemPackages = with pkgs; [
    bottom
    zoxide
    neovim
    zellij
    atuin
    ripgrep
    fd
    sd
    bat
    eza
    fzf
    wget
    git
    git-crypt
    htop
    gnupg
    gh
    dust
    just
    pinentry-curses
  ];
}
