{ inputs, ... }:
let
  lib = inputs.nixpkgs-unstable.legacyPackages."x86_64-linux".lib;

  inherit (builtins)
    baseNameOf
    filter
    elem
    readFile
    fromTOML
    listToAttrs
    ;

  inherit (lib)
    hasSuffix
    nameValuePair
    mapAttrs
    concatMapAttrs
    mkIf
    optionalAttrs
    ;

  inherit (lib.filesystem) listFilesRecursive;

in
rec {
  readInVarFile = path: path |> readFile |> fromTOML;

  mkImportList =
    path:
    path
    |> listFilesRecursive
    |> filter (filePath: hasSuffix ".nix" (baseNameOf filePath))
    |> filter (
      filePath:
      !elem (baseNameOf filePath) [
        "default.nix"
        "test.nix"
      ]
    );

  findAllHosts =
    hostsPath:
    let
      isHostVarFile = path: path |> baseNameOf |> toString |> hasSuffix ".toml";
    in
    filter isHostVarFile (listFilesRecursive hostsPath);

  mkHostAttrs =
    # reads the toml file with the same name as host in host folder
    # and make an attrset with host vars
    let
      mkAttr =
        path:
        nameValuePair (path |> dirOf |> baseNameOf) {
          hostPath = dirOf path;
          inherit (path |> readFile |> fromTOML)
            system
            channel
            mainUser
            makeTestHost
            ;
        };
    in
    hostVarFilePathList: hostVarFilePathList |> map mkAttr |> listToAttrs;

  mkHost =
    hostName: attrs:
    let
      inherit (attrs)
        hostPath
        system
        mainUser
        channel
        makeTestHost
        ;
      nixpkgs = builtins.getAttr channel inputs;
      specialArgs = {
        inherit inputs;
        evilib = inputs.self.lib;
        configPath = inputs.self.outPath + "/hosts/config";
        dotFilesPath = inputs.self.outPath + "/dotfiles";
        resourcesPath = inputs.self.outPath + "/resources";
      };
      modules = [
        # optional config options
        ../modules
        ../hosts/common
        # users
        ../users/${mainUser}-${hostName}
        # hosts path in hosts folder
        hostPath
        {
          nixpkgs.hostPlatform = system;
          networking.hostName = if makeTestHost then "${hostName}-test" else hostName;
          evilwoods.vars.mainUser = mainUser;
          evilwoods.vars.isTestEnv = makeTestHost;
        }
      ];
    in
    {
      ${hostName} = nixpkgs.lib.nixosSystem {
        inherit specialArgs modules;
      };
    }
    // optionalAttrs makeTestHost {
      ${hostName + "-test"} = nixpkgs.lib.nixosSystem {
        inherit specialArgs modules;
      };
    };

  mkHosts = hostsPath: concatMapAttrs mkHost (mkHostAttrs (findAllHosts hostsPath));
}
