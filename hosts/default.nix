{ inputs, lib, ... }:
let
  inherit (builtins)
    readDir
    filter
    attrNames
    pathExists
    listToAttrs
    fromTOML
    readFile
    toString
    baseNameOf
    dirOf
    ;

  inherit (lib)
    mapAttrs
    nameValuePair
    hasSuffix
    ;

  inherit (lib.filesystem) listFilesRecursive;

  findAllHosts =
    let
      isHostVarFile = path: path |> baseNameOf |> toString |> hasSuffix ".toml";
    in
    filter isHostVarFile (listFilesRecursive ./.);

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

in
mapAttrs (mkHost { inherit inputs; }) (hostListToHostAttrs findAllHosts)
