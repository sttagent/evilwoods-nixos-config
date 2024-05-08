{ config, pkgs, lib, ... }:

{
  imports = [
    ./shared-configuration.nix
    ./main-user.nix
  ];
}
