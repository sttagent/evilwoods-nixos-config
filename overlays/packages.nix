final: prev: {
  pythonPackagesExtensions = prev.pythonPackagesExtensions ++ [
    (pythonFinal: pythonPrev: {
      xonsh-direnv = pythonFinal.callPackage ../packages/xonsh-direnv.nix { };
      xontrib-fish-completer = pythonFinal.callPackage ../packages/xontrib-fish-completer.nix { };
    })
  ];
}
