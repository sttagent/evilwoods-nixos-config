{
  inputs,
  config,
  evilib,
  pkgs,
  dotFilesPath,
  ...
}: # os configuration is reachable via nixosConfig
let
  inherit (evilib.readInVarFile ./vars.toml) currentUser;
  inherit (builtins) toString;
in
{
  sops.secrets.ryne-password = {
    sopsFile = toString (inputs.secrets + "/secrets/ryne/ryne.yaml");
    neededForUsers = true;
  };

  users.users = {
    ${currentUser} = {
      isNormalUser = true;
      createHome = true;
      home = "/home/${currentUser}";
      description = "Ryne Ramanauskas";
      hashedPasswordFile = config.sops.secrets.ryne-password.path;
      extraGroups = [
        "wheel"
        "networkmanager"
      ]; # Enable ‘sudo’ for the user.
    };

  };

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "bak";
    users.${currentUser} = {
      home = {
        username = "${currentUser}";
        homeDirectory = "/home/${currentUser}";

        stateVersion = config.system.stateVersion;
      };

      programs = {
        home-manager.enable = true;
      };
    };
  };
}
