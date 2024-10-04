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

  evilwoods = {
    rsyncBackup.defaults = {
      srcSubvol = "/var/storage/internal-ssd/storage";
      snapshotSubvol = "/var/storage/internal-ssd/snapshots";
      dstSubvol = "/var/storage/external-hdd/backups";
      rsyncPrefix = "rsync";
      snapshotPrefix = "snapshot";
    };
  };

  # networking.interfaces.enp3s0.useDHCP = lib.mkDefault true;
}
