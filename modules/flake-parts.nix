{
  self,
  inputs,
  config,
  ...
}:
let
  inherit (inputs.nixpkgs.lib)
    mkOption
    types
    hasPrefix
    nameValuePair
    removePrefix
    toLower
    ;
  inherit (builtins) attrNames filter listToAttrs;
  mkHost =
    hostName:
    let
      hostNixpkgs = config.hosts.${hostName}.nixpkgs;
      attrName = hostName |> removePrefix "host" |> toLower;
      mkNixosSystem = inputs.${hostNixpkgs}.lib.nixosSystem {
        modules = [ self.modules.nixos."${hostName}" ];
      };
    in
    nameValuePair "${attrName}" mkNixosSystem;
  mkNixosConfigs =
    attrNames self.modules.nixos
    |> filter (hostName: hasPrefix "host" hostName)
    |> filter (
      hostName:
      !(builtins.elem hostName [
        "hostEvilcloud"
        "hostNecronomicon"
      ])
    )
    |> map mkHost
    |> listToAttrs;

in
{
  options.paths = {
    dotFilesPath = mkOption {
      type = types.path;
      default = inputs.self.outPath + "/dotfiles";
    };
    resourcesPath = mkOption {
      type = types.path;
      default = inputs.self.outPath + "/resources";
    };
  };

  imports = [ inputs.flake-parts.flakeModules.modules ];

  config = {
    flake.nixosConfigurations = mkNixosConfigs;

    systems = [ "x86_64-linux" ];

    perSystem =
      { system, ... }:
      {
        _module.args.pkgs-2511 = inputs.nixpkgs-2511.legacyPackages.${system};
      };

  };
}
