{
  pkgs ? import <nixpkgs> { },
  ...
}:
pkgs.python3Packages.buildPythonPackage rec {
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
}
