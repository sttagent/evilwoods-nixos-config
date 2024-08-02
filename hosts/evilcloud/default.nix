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
    ./services/acme.nix
    ./services/caddy.nix
    ./services/blocky.nix
    ./services/ntfy.nix
    ./services/fail2ban.nix
    
    ./testing.nix
  ];
}
