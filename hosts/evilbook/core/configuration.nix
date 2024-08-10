{ inputs, ... }:
{
  imports = [
    ../../common/core
    inputs.disko.nixosModules.disko
  ];

  system.stateVersion = "24.05";
}
