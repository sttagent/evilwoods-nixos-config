{
  flake.modules.nixos.base =
    { pkgs, ... }:
    {
      programs = {
        nh.enable = true;
        fish.enable = true;
      };

      environment.systemPackages = with pkgs; [
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
        nix-tree
        nixos-option
        cachix
        jq
      ];
    };
}
