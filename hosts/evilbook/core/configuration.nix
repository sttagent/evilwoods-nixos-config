{ inputs, configPath, ... }:
{
  imports = [
    (configPath + "/hardware/boot/systemd-boot.nix")
    (configPath + "/core")
    inputs.disko.nixosModules.disko
  ];

  system.stateVersion = "24.05";
}
