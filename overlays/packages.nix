pkgs: self: super: {
  xonsh-direnv = super.python3Packages.callPackage ../packages/xonsh-direnv.nix { };
  xontrib-fish-completer =
    super.python3Packages.callPackage ../packages/xontrib-fish-completer.nix
      { };
}
