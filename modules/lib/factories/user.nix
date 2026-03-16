{ inputs, config, ... }:

{
  config.flake.lib.flake-config = config;
  config.flake.lib.factory.user =
    {
      userName,
      desc ? null,
      isAdmin ? false,
      extraConfig ? { },
      extraHomeConfig ? { },
    }:
    {
      config,
      lib,
      ...
    }:
    let
      secretsPath = toString inputs.evilsecrets;
    in
    {

      sops.secrets."${userName}-password" = {
        sopsFile = "${secretsPath}/secrets/${userName}/default.yaml";
        neededForUsers = true;
      };

      users.users = {
        ${userName} = lib.mkMerge [
          {
            isNormalUser = true;
            description = if isNull desc then userName else desc;
            hashedPasswordFile = config.sops.secrets."${userName}-password".path;
            extraGroups = [
            ];
          }

          (lib.mkIf isAdmin {
            extraGroups = [
              "wheel"
              "networkmanager"
            ];
          })

          extraConfig
        ];
      };
      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        backupFileExtension = "bak";
        users.${userName} = lib.mkMerge [
          {
            home = {
              username = "${userName}";
              homeDirectory = config.users.users.${userName}.home;

              stateVersion = config.system.stateVersion;
            };
            programs.home-manager.enable = true;
          }
          extraHomeConfig
        ];
      };
    };
}
