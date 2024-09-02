{ inputs, configPath, ... }:
{
  imports = [
    (configPath + "/hardware/boot/systemd-boot.nix")
    (configPath + "/common/core")
    inputs.disko.nixosModules.disko
  ];

  system.stateVersion = "24.05";
}
