{ pkgs, ... }:
{
  programs = {
    xonsh = {
      enable = true;
      extraPackages = ps: [
        ps.questionary
      ];
    };
    direnv.enable = true;
    zoxide.enable = true;
  };
}
