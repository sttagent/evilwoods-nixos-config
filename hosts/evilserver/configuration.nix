{
  inputs,
  configPath,
  ...
}:
{
  imports = [
    (configPath + "/common")
    (configPath + "/hardware/boot/systemd-boot.nix")
    (configPath + "/server")

    inputs.sops-nix-2405.nixosModules.sops
    inputs.home-manager-2405.nixosModules.home-manager
  ];

  system.stateVersion = "24.05";

  nix.settings = {
    trusted-users = [
      "root"
      "@wheel"
    ];
  };

  evilwoods = {
    vars = {
      tailscaleIP = "100.94.134.11";
    };
    storage = {
      externalHddBackupVolume = "/var/storage/external-hdd/backup";
      externalHddSnapshotVolume = "/var/storage/external-hdd/snapshots";
      internalSsdContainersVolume = "/var/storage/internal-ssd/containers";
      internalSsdStorageVolume = "/var/storage/internal-ssd/storage";
      internalSsdSnapshotVolume = "/var/storage/internal-ssd/snapshots";
    };
    rsyncBackup.defaults = {
      srcSubvol = "/var/storage/internal-ssd/storage";
      snapshotSubvol = "/var/storage/internal-ssd/snapshots";
      dstSubvol = "/var/storage/external-hdd/backups";
      rsyncPrefix = "rsync";
      snapshotPrefix = "snapshot";
    };
  };

  networking = {
    useDHCP = false;
    defaultGateway = "192.168.1.1";
    interfaces.enp2s0 = {
      useDHCP = false;
      ipv4.addresses = [
        {
          address = "192.168.1.2";
          prefixLength = 24;
        }
      ];
    };
  };

  services.fstrim.enable = true;

  programs.nix-ld = {
    enable = true;
  };

  virtualisation = {
    oci-containers = {
      backend = "podman";
    };
  };

  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGFc8oFtu7i4WBlbcDMB7ua9cHJW2bzeomrLFddokw7v aitvaras@evilbook"
  ];

  # networking.interfaces.enp3s0.useDHCP = lib.mkDefault true;
}
