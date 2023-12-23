{lib, pkgs, inputs, ...}: {
  imports = [
    ./shared-config.nix
    ./shared-packages.nix
  ];
}