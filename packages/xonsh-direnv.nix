{
  lib,
  buildPythonPackage,
  pip,
  fetchFromGitHub,
}:
buildPythonPackage rec {
  name = "xonsh-direnv";
  version = "1.6.4";
  # format = "pyproject";
  src = fetchFromGitHub {
    owner = "74th";
    repo = "${name}";
    rev = "${version}";
    sha256 = "1SLb4gx73NSUG1Fshmvj+21hD9j2UnK+RcTolq1zJiI=";
  };
  nativeBuildInputs = [
    pip
  ];
  meta = {
    homepage = "https://github.com/74th/xonsh-direnv";
    description = "direnv support for the xo}nsh shell";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
