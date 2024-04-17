{ inputs, extraModules ? [ ], ... }:
let
  evilib = import ../lib { inherit (inputs.nixpkgs-unstable) lib; };
  
  mkHost = {hostname, users ? [], nixpkgs, stateVersion} @ thisHost: {
    name = "${hostname}";
    value = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ../modules
        ./common
        ./${hostname}
      ] ++ extraModules;

      specialArgs = {
        inherit inputs thisHost;
      };
    };
  };
  
  mkHosts = hostList: builtins.map mkHost hostList;
in
builtins.listToAttrs (mkHosts [
  { hostname = "evilbook"; nixpkgs = inputs.nixpkgs-unstable; stateVersion = "24.05";}
])
