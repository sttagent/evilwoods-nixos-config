{
  config,
  evilib,
  pkgs,
  dotFilesPath,
  ...
}: # os configuration is reachable via nixosConfig
let
  inherit (evilib.readInVarFile ./vars.toml) currentUser;
  inherit (config.evilwoods.vars) shell;
in
{
  sops.secrets.aitvaras-password.neededForUsers = true;

  users.users = {
    ${currentUser} = {
      isNormalUser = true;
      createHome = true;
      home = "/home/${currentUser}";
      description = "Arvydas Ramanauskas";
      hashedPasswordFile = config.sops.secrets.aitvaras-password.path;
      extraGroups = [
        "wheel"
        "networkmanager"
      ]; # Enable ‘sudo’ for the user.
      shell = pkgs.fish;
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
