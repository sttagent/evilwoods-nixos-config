{ inputs, ... }:
{
  imports = [
    ../../common/core

    inputs.disko-2405.nixosModules.disko
  ];
}
