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
    hosts:
    mapAttrs' (
      host: _:
      nameValuePair host {
        hostPath = ./${host};
      inherit (fromTOML (readFile ./${host}/${host}.toml)) system nixpkgs mainUser;
      }
    ) (genAttrs hosts (host: null));

  mkHost =
    { inputs, ... }:
    hostName: attrs:
    let
      inherit (attrs) hostPath system mainUser;
      nixpkgs = builtins.getAttr attrs.nixpkgs inputs;
      specialArgs = {
        inherit inputs;
        evilib = inputs.self.lib;
        configPath = inputs.self.outPath + "/hosts/config";
      };
    in
    nixpkgs.lib.nixosSystem {
      inherit system specialArgs;
      modules = [
        ../modules
        { networking.hostName = hostName; }
        hostPath
        ../users/${mainUser}-${hostName}
      ];
    };

in
mapAttrs (mkHost { inherit inputs; }) (hostListToHostAttrs findAllHosts)
