{ pkgs, ... }:
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
    gnupg
    dust
    just
    difftastic
  ];
}
