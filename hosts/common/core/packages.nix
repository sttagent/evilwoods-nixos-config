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
    htop
    gnupg
    gh
    dust
    just
    difftastic
  ];
}
