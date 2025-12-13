currentUser:
{
  inputs,
  config,
  ...
}: # os configuration is reachable via nixosConfig
let
  inherit (builtins) toString;
  secretsPath = toString inputs.evilsecrets;
in
{
  sops.secrets.ryne-password = {
    sopsFile = "${secretsPath}/secrets/ryne/ryne.yaml";
    neededForUsers = true;
  };

  users.users = {
    ${currentUser} = {
      isNormalUser = true;
      description = "Ryne Ramanauskas";
      hashedPasswordFile = config.sops.secrets.ryne-password.path;
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

        inherit (config.system) stateVersion;
      };

      programs = {
        home-manager.enable = true;
      };
    };
  };
}
