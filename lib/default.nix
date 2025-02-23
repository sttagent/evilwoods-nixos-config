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

  hostListToHostAttrs =
    # reads the toml file with the same name as host in host folder
    # and make an attrset with host vars
    let
      mkAttr =
        path:
        nameValuePair (path |> dirOf |> baseNameOf) {
          hostPath = dirOf path;
          inherit (path |> readFile |> fromTOML) system channel mainUser;
        };
    in
    hostVarFilePathList: hostVarFilePathList |> map mkAttr |> listToAttrs;

  mkHost =
    { inputs, ... }:
    hostName: attrs:
    let
      inherit (attrs)
        hostPath
        system
        mainUser
        channel
        ;
      nixpkgs = builtins.getAttr channel inputs;
      specialArgs = {
        inherit inputs;
        evilib = inputs.self.lib;
        configPath = inputs.self.outPath + "/hosts/config";
        dotFilesPath = inputs.self.outPath + "/dotfiles";
        resourcesPath = inputs.self.outPath + "/resources";
      };
    in
    nixpkgs.lib.nixosSystem {
      inherit specialArgs;
      modules = [
        # optional config options
        ../modules
        # users
        ../users/${mainUser}-${hostName}
        # hosts path in hosts folder
        hostPath

        {
          nixpkgs.hostPlatform = system;
          networking.hostName = hostName;
          evilwoods.vars.mainUser = mainUser;
        }
      ];
    };

  mkHosts =
    hostsPath: mapAttrs (mkHost { inherit inputs; }) (hostListToHostAttrs (findAllHosts hostsPath));
}
