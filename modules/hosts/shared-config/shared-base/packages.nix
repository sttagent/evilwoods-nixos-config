{
  den.aspects.hostBase = {
    nixos = { pkgs, ... }: {
      programs = {
        nh.enable = true;
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
        jq
      ];
    };
  };
}
