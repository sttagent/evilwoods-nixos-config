{
  lib,
  buildPythonPackage,
  pip,
  fetchFromGitHub,
}:
buildPythonPackage rec {
  name = "xontrib-fish-completer";
  version = "0.0.1";
  # format = "pyproject";
  src = fetchFromGitHub {
    owner = "xonsh";
    repo = "${name}";
    rev = "${version}";
    sha256 = "PhhdZ3iLPDEIG9uDeR5ctJ9zz2+YORHBhbsiLrJckyA=";
  };
  nativeBuildInputs = [
    pip
  ];
  meta = {
    homepage = "https://github.com/xonsh/xontrib-fish-completer";
    description = " Populate rich completions using fish and remove the default bash based completer in xonsh shell. ";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
