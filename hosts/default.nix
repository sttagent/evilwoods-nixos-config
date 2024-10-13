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
        host = ./${host};
        hostVars = fromTOML (readFile ./${host}/${host}.toml);
      }
    ) (genAttrs hosts (host: null));

  mkHost =
    { inputs, ... }:
    hostName: attrs:
    let
      inherit (attrs.hostVars) system;
      inherit (attrs) host;
      nixpkgs = builtins.getAttr attrs.hostVars.nixpkgs inputs;
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
        host
        ../users/aitvaras-${hostName}
      ];
    };

in
mapAttrs (mkHost { inherit inputs; }) (hostListToHostAttrs findAllHosts)
