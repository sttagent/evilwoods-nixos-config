{ inputs, configPath, ... }:
{
  imports = [
    (configPath + "/common/core")
    (configPath + "/hardware/boot/systemd-boot.nix")
    
    inputs.disko-2405.nixosModules.disko
  ];

  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGFc8oFtu7i4WBlbcDMB7ua9cHJW2bzeomrLFddokw7v aitvaras@evilbook"
  ];

  system.stateVersion = "24.05";
}
