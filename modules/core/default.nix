{ config, pkgs, lib, ...}:

{
  imports = [
    ./core-packages.nix
  ];
  
  config = {
    # Set your time zone.
    time.timeZone = "Europe/Stockholm";
  };
}
