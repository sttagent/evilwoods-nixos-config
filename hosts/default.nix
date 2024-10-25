{ inputs, lib, ... }:
let
  inherit (builtins)
    readDir
    filter
    attrNames
    pathExists
    fromTOML
    readFile
    dirOf
    ;

  inherit (lib)
    filterAttrs
    mapAttrs
    mapAttrs'
    nameValuePair
    genAttrs
    listFilesRecursive
    hasSuffix
    ;

  findAllHosts =
    let
      isDiretory = n: v: (v == "directory");
      isHost = dirName: pathExists ./${dirName}/${dirName}.toml;
    in
    filter isHost (attrNames (filterAttrs isDiretory (readDir ./.)));

  findAllHosts' =
    let
      isHostVarFile = path: hasSuffix ".toml" path;
    in
    map dirOf (filter isHostVarFile (listFilesRecursive ./.));

  hostListToHostAttrs =
    # reads the toml file with the same name as host in host folder
    # and make an attrset with host vars
    hosts:
    mapAttrs' (
      host: _:
      nameValuePair host {
        hostPath = ./${host};
        inherit (fromTOML (readFile ./${host}/${host}.toml)) system channel mainUser;
      }
    ) (genAttrs hosts (host: null));

  mkHost =
    { inputs, ... }:
    hostName: attrs:
    let
      inherit (attrs) hostPath system mainUser channel;
      nixpkgs = builtins.getAttr channel inputs;
      specialArgs = {
        inherit inputs;
        evilib = inputs.self.lib;
        configPath = inputs.self.outPath + "/hosts/config";
      };
    in
    nixpkgs.lib.nixosSystem {
      inherit system specialArgs;
      modules = [
        # optional config options
        ../modules
        # users
        ../users/${mainUser}-${hostName}
        # hosts path in hosts folder
        hostPath

        { 
            networking.hostName = hostName;
            evilwoods.vars.mainUser = mainUser;
        }
      ];
    };

in
mapAttrs (mkHost { inherit inputs; }) (hostListToHostAttrs findAllHosts)
