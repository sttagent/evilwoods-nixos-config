{ config, pkgs, lib, ... }:

{
  config = {
    environment.systemPackages = with pkgs; [
      zoxide
      neovim
      lazygit
      zellij
      atuin
      ripgrep
      fd
      bat
      eza
      starship
      zoxide
      fzf
      wget
      git
      git-crypt
      htop
      gnupg
      bottom
    ];
  };
}
