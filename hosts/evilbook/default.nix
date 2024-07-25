{
  imports = [
    ../common/core
    ../common/desktop
    ../common/gnome

    ../common/optional/zsa.nix

    ./partitions.nix
    ./hardware.nix
    ./configuration.nix
    ./packages.nix
  ];
}
