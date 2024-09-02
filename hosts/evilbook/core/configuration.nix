{ inputs, ... }:
{
  imports = [
    ../../common/hardware/boot/systemd-boot.nix
    ../../common/core
    inputs.disko.nixosModules.disko
  ];

  system.stateVersion = "24.05";
}
