{ inputs, lib, ... }:
let
  inherit (builtins)
    readDir
    filter
    attrNames
    pathExists
    fromTOML
    readFile
    ;

  inherit (lib)
    filterAttrs
    ;

  findAllHosts =
    let
      isDiretory = n: v: (v == "directory");
      isHost = dirName: pathExists (./. + "/${dirName}/${dirName}.toml");
    in
    filter isHost (attrNames (filterAttrs isDiretory (readDir ./.)));
  hostListToHostAttrs =
    hosts:
    builtins.listToAttrs (
      lib.forEach hosts (
        host:
        lib.nameValuePair "${host}" {
          "host" = ./${host};
          "hostVars" = fromTOML (readFile (./. + "/${host}/${host}.toml"));
        }
      )
    );

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
    {
      ${hostName} = nixpkgs.lib.nixosSystem {
        inherit system specialArgs;
        modules = [
          ../modules
          { networking.hostName = hostName; }
          host
          ../users/aitvaras-${hostName}
        ];
      };
    };

  mapHosts = f: hosts: lib.concatMapAttrs f hosts;
in
mapHosts (mkHost { inherit inputs; }) (hostListToHostAttrs findAllHosts)
