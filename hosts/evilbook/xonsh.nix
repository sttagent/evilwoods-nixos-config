{ pkgs, ... }:
{
  programs = {
    xonsh = {
      enable = true;
      package = pkgs.xonsh.override {
        extraPackages = ps: [
          ps.questionary
          (ps.buildPythonPackage rec {
            name = "xonsh-direnv";
            version = "1.6.4";
            # format = "pyproject";
            src = pkgs.fetchFromGitHub {
              owner = "74th";
              repo = "${name}";
              rev = "${version}";
              sha256 = "1SLb4gx73NSUG1Fshmvj+21hD9j2UnK+RcTolq1zJiI=";
            };
            nativeBuildInputs = [
              pkgs.python3Packages.pip
            ];
            meta = {
              homepage = "https://github.com/74th/xonsh-direnv";
              description = "direnv support for the xonsh shell";
              license = pkgs.lib.licenses.mit;
              maintainers = [ ];
            };
          })

          (ps.buildPythonPackage rec {
            name = "xontrib-fish-completer";
            version = "0.0.1";
            # format = "pyproject";
            src = pkgs.fetchFromGitHub {
              owner = "xonsh";
              repo = "${name}";
              rev = "${version}";
              sha256 = "PhhdZ3iLPDEIG9uDeR5ctJ9zz2+YORHBhbsiLrJckyA=";
            };
            nativeBuildInputs = [
              pkgs.python3Packages.pip
            ];
            meta = {
              homepage = "https://github.com/xonsh/xontrib-fish-completer";
              description = " Populate rich completions using fish and remove the default bash based completer in xonsh shell. ";
              license = pkgs.lib.licenses.mit;
              maintainers = [ ];
            };
          })
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
