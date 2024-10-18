{
  pkgs ? import <nixpkgs> { },
  ...
}:
pkgs.python3Packages.buildPythonPackage rec {
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
    description = "direnv support for the xo}nsh shell";
    license = pkgs.lib.licenses.mit;
    maintainers = [ ];
  };
}
