{ modulesPath, ... }:
{
  imports = [
    ../common/core
    ../common/bootstrap

    ../evilcloud/evilcloud-configuration.nix
    (import ./evilcloud/evilcloud-partition-scheme.nix)
    (modulesPath + "/profiles/qemu-guest.nix")
  ];
}
