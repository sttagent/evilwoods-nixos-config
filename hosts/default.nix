{ inputs, ... }:
let
  evilib = import ../lib { inherit (inputs.nixpkgs-unstable) lib; };
  
  mkHost = {hostname, users ? [], nixpkgs, stateVersion, extraModules ? [], ...} @ thisHost: {
    name = "${hostname}";
    value = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ../modules
        ./common
        ../homes/common

        ../homes/${evilib.mainUser}
        ./${hostname}
      ] ++ extraModules;

      specialArgs = {
        inherit inputs thisHost evilib;
      };
    };
  };
  
  mkHosts = hostList: builtins.map mkHost hostList;
in
builtins.listToAttrs (mkHosts [
  { 
    hostname = "evilbook";
    nixpkgs = inputs.nixpkgs-unstable;
    stateVersion = "24.05";
    extraModules = [
      inputs.disko.nixosModules.disko
      inputs.home-manager.nixosModules.home-manager
      inputs.sops-nix.nixosModules.sops
    ];
  }
])
