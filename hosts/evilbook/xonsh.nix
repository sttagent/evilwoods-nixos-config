{ pkgs, ... }:
{
  programs = {
    xonsh = {
      enable = true;

      package = pkgs.xonsh.override {
        extraPackages = ps: [
          ps.questionary
          ps.xontrib-fish-completer
          ps.xonsh-direnv
        ];
      };
    };
  };
}
