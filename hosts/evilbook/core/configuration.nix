{ inputs, ... }:
{
  imports = [
    ../../common/core
    inputs.disko.nixosModules.disko
  ];
}
