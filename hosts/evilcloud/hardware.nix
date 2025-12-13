{ modulesPath, ... }:
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];
  evilwoods.vmGuest.enabled = true;
}
