{ config, pkgs, lib, ... }:

with lib;

let
  mainUser = config.evilwoods.mainUser;
in
{
  options.evilwoods.mainUser = mkOption {
    type = types.str;
    default = "aitvaras";
    description = "The primary user of evilwoods.";
  };

  config = {
    /*  users.users = {
      ${mainUser} = {
        isNormalUser = true;
        description = "Arvydas Ramanauskas";
        hashedPassword = "$6$r5XosfFY6X0yH0kg$sPHtZm25ZWpsx86cdKUsjr8fMv6AU6Jmj26H9qBbRKVOJx5SUBw2sSIwXx5FxAvarWmukal0r7.Biy1wpClwd1";
        extraGroups = [ "wheel" "networkmanager" ]; # Enable ‘sudo’ for the user.
        shell = pkgs.fish;
      };
    }; */
  };


}
