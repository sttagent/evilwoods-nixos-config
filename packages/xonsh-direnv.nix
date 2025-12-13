{
  lib,
  buildPythonPackage,
  pip,
  fetchFromGitHub,
}:
buildPythonPackage rec {
  name = "xonsh-direnv";
  version = "1.6.5";
  # format = "pyproject";
  src = fetchFromGitHub {
    owner = "74th";
    repo = "${name}";
    rev = "${version}";
    sha256 = "huBJ7WknVCk+WgZaXHlL+Y1sqsn6TYqMP29/fsUPSyU=";
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
