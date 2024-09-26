{ configPath, ... }:
{
  imports = [
    (configPath + "/hardware/vm-guest.nix")
  ];
}
