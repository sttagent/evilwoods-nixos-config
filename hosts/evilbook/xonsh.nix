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
      config = ''
        xontrib load coreutils direnv fish_completer
        #
        # aliases["ls"] = "eza"
        aliases["ll"] = "eza -l"
        aliases["lla"] = "eza -l -a"
        #
        execx($(starship init xonsh))
        execx($(zoxide init xonsh), 'exec', __xonsh__.ctx, filename='zoxide')
        execx($(atuin init xonsh))
      '';
    };
  };
}
