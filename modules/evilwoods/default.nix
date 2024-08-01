{
  config,
  pkgs,
  lib,
  ...
}:

{
  imports = [
    ./vars.nix
    ./rsync-backup.nix
  ];
}
