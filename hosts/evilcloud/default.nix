{ modulesPath, ... }:
{
  imports = [
    ../common/core

    (import ./partitions.nix { })
    ./configuration.nix
    (modulesPath + "/profiles/qemu-guest.nix")
  ];
}
