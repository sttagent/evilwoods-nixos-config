{ pkgs, ... }:
{
  programs = {
    xonsh = {
      enable = true;
      extraPackages = ps: [
        ps.questionary
        # ps.xonsh-direnv
      ];
    };
    direnv.enable = true;
    zoxide.enable = true;
  };
}
