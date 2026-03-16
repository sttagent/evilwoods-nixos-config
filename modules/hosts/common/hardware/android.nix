{
  flake.modules.nixos.hardwareAndroid =
    { config, pkgs, ... }:
    let
      inherit (config.evilwoods.variables) mainUser;
    in
    {
      users.users.${mainUser}.extraGroups = [ "adbusers" ];
      environment.systemPackages = with pkgs; [
        android-tools
      ];
    };
}
