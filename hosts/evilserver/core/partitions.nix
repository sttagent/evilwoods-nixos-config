{ configPath, ... }:
{
  imports = [ (configPath + "/hardware/partition_schemes/simple_vm_guest.nix") ];
}
