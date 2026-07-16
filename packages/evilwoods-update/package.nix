{
  python3Packages,
  python3,
  mkShell,
}:
python3Packages.buildPythonApplication rec {
  name = "evilwoods-update";
  src = ./src;
  pyproject = true;

  build-system = with python3Packages; [
    setuptools
  ];

  passthru = {
    devShell = mkShell {
      packages = [ python3 ];
      shellHook = ''
        cd modules/packages/evilwoods-update/src || true
      '';
    };
  };

}
