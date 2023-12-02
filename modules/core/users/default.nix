{ config, pkgs, lib, ... }:

with lib;

let
  primaryUser = config.evilcfg.primaryUser;
in
{
  options.evilcfg.primaryUser = mkOption {
    type = types.str;
    default = "aitvaras";
    description = "The primary user of evilcfg.";
  };

  config = {
    # disable user creation. needed to disable root account
    users.mutableUsers = false;

    # Define a user account. Don't forget to set a password with ‘passwd’.
    users.users = {
      root.hashedPassword = "!";

      ${primaryUser} = {
        isNormalUser = true;
        description = "Arvydas Ramanauskas";
        hashedPassword = "$6$r5XosfFY6X0yH0kg$sPHtZm25ZWpsx86cdKUsjr8fMv6AU6Jmj26H9qBbRKVOJx5SUBw2sSIwXx5FxAvarWmukal0r7.Biy1wpClwd1";
        extraGroups = [ "wheel" "networkmanager" ]; # Enable ‘sudo’ for the user.
        shell = pkgs.fish;
      };
    };
  };


}
