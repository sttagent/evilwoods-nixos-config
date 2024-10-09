{
  inputs,
  configPath,
  modulesPath,
  ...
}:
{
  imports = [
    (configPath + "/hardware/boot/systemd-boot.nix")
    (configPath + "/core")
    # (modulesPath + "/profiles/perlless.nix")
    inputs.disko.nixosModules.disko
  ];

  services.userborn.enable = true;
  # system.etc.overlay.enable = true;

  system.stateVersion = "24.05";
}
