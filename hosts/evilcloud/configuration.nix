{
  inputs,
  config,
  modulesPath,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ../common/optional/base
    ../common/optional/server
    inputs.sops-nix-2405.nixosModules.sops
    inputs.home-manager-2405.nixosModules.home-manager
  ];
  nix.settings = {
    trusted-users = [
      "root"
      "@wheel"
    ];
  };

  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMQa0ofDMxQ2x8WC8KkcsERfmmYa89tlhu11dJ0J9Pds root@evilcloud"
  ];

  # networking.interfaces.enp3s0.useDHCP = lib.mkDefault true;
}
