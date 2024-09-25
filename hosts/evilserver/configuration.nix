{
  inputs,
  configPath,
  ...
}:
{
  imports = [
    (configPath + "/common")
    (configPath + "/server")

    inputs.sops-nix-2405.nixosModules.sops
    inputs.home-manager-2405.nixosModules.home-manager

  ];

  nix.settings = {
    trusted-users = [
      "root"
      "@wheel"
    ];
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

  # fileSystems = {
  #   "/var/backups" = {
  #     device = "/dev/disk/by-label/External-backup";
  #     fsType = "btrfs";
  #     options = [
  #       "defaults"
  #       "noatime"
  #       "compress=zstd"
  #     ];
  #   };
  # };

  evilwoods = {
    rsyncBackup.defaults = {
      srcSubvol = "/var/storage";
      snapshotSubvol = "/var/snapshots";
      dstSubvol = "/var/backups";
      rsyncPrefix = "rsync";
      snapshotPrefix = "snapshot";
    };
  };

  # networking.interfaces.enp3s0.useDHCP = lib.mkDefault true;
}
