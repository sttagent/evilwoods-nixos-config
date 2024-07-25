{ modulesPath, ... }:
{
  imports = [
    ../common/core

    (import ./evilcloud-partition-scheme.nix { })
    ./evilcloud-configuration.nix
    (modulesPath + "/profiles/qemu-guest.nix")
  ];
}
