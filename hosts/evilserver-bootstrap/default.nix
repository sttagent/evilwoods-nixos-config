{ lib, pkgs, ... }:
{
  imports = [
    ../common/core
    ../common/bootstrap
    (import ../evilserver/evilserver-partition-scheme.nix { })
    ../evilserver/evilserver-configuration.nix
  ];
}
