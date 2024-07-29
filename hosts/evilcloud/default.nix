{ modulesPath, ... }:
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    (modulesPath + "/profiles/qemu-guest.nix")

    ../common/core

    ./boot.nix
    (import ./partitions.nix { })
    ./configuration.nix

    # services
    ./services/blocky.nix
    ./services/fail2ban.nix
  ];
}
