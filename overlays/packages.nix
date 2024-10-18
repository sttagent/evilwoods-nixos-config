pkgs: self: super: {
  xonsh-direnv = super.callPackage ../packages/xonsh-direnv.nix { inherit pkgs; };
  xontrib-fish-completer = super.callPackage ../packages/xontrib-fish-completer.nix { inherit pkgs; };
}
