{ inputs, hosts, ... }:
let
  evilib = inputs.self.lib;

  buildNormalConfig =
    {
      hostname,
      nixpkgs,
      stateVersion,
      extraUsers ? [ ],
      extraModules ? [ ],
      ...
    }:
    {
      name = "${hostname}";
      value = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ../modules

          ../users/${evilib.defaults.mainUser}-${hostname}
          ./${hostname}

          {
            networking.hostName = hostname;
            system.stateVersion = stateVersion;
          }

        ] ++ extraModules;

        specialArgs = {
          inherit inputs evilib;
        };
      };
    };

  buildBootstrapConfig =
    {
      hostname,
      nixpkgs,
      stateVersion,
      extraUsers ? [ ],
      extraModules ? [ ],
      ...
    }:
    {
      name = "${hostname}-bootstrap";
      value = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ../modules
          ./common/bootstrap

          (import ./${hostname}/partitions.nix { })
          ./${hostname}/boot.nix

          {
            networking.hostName = hostname;
            system.stateVersion = stateVersion;
          }

        ] ++ extraModules;

        specialArgs = {
          inherit inputs evilib;
        };
      };
    };

  mkHost =
    { bootstrap, ... }@host:
    [ (buildNormalConfig host) ] ++ (if bootstrap then [ (buildBootstrapConfig host) ] else [ ]);

  mkHosts = hostList: builtins.map mkHost hostList;
in
builtins.listToAttrs (builtins.concatLists (mkHosts hosts))
