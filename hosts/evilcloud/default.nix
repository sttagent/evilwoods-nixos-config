{ lib
, pkgs
, ...
}: {
  imports = [
    ../common/core.nix
    ../common/packages.nix
    ../common/tailscale.nix
    (import ./evilcloud-partition-scheme.nix { })
    ./evilcloud-hardware-configuration.nix
    ./evilcloud-configuration.nix

    # Services
    ./samba.nix
  ];
}
