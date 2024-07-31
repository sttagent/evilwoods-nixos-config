{ config, pkgs, lib, ... }:

{
  imports = [
    ./options.nix
    ./rsync-backup.nix
  ];
}
