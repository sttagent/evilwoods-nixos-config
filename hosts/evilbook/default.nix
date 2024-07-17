{
  imports = [
    ../common/core
    ../common/desktop
    ../common/gnome

    ../common/optional/zsa.nix

    ./evilbook-partition-scheme.nix
    ./evilbook-hardware-configuration.nix
    ./evilbook-configuration.nix
    ./evilbook-packages.nix
  ];
}
