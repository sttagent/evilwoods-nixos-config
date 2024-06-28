{ lib, pkgs, ... }:
{
  imports = [
    ../common/core.nix
    ../evilcloud/evilcloud-partition-scheme.nix
    ../evilcloud/evilcloud-configuration.nix
  ];

  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGFc8oFtu7i4WBlbcDMB7ua9cHJW2bzeomrLFddokw7v aitvaras@evilbook"
  ];
}
