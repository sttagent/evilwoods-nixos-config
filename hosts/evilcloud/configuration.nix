{ config, lib, pkgs, ... }:
{

  boot = {
    initrd = {
      verbose = false;
    };
  };

  nix.settings = {
    trusted-users = [
      "root"
      "@wheel"
    ];
  };


  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGFc8oFtu7i4WBlbcDMB7ua9cHJW2bzeomrLFddokw7v aitvaras@evilbook"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMQa0ofDMxQ2x8WC8KkcsERfmmYa89tlhu11dJ0J9Pds root@evilcloud"
  ];

  # networking.interfaces.enp3s0.useDHCP = lib.mkDefault true;
}
