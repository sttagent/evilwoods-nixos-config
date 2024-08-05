{ lib, ... }:
rec {
  sourcePath = ./.;
  defaults = {
    defaultSystem = "x86_64-linux";
    mainUser = "aitvaras";
  };

  isHostVarFile = file: (file.type == "regular") && (file.name == "host-vars.nix");
  isValidImportFile =
    file:
    (file.type == "regular")
    && (file.hasExt "nix")
    && !(builtins.elem file.name [
      "default.nix"
      "host-vars.nix"
      "test.nix"
      "bootstrap.nix"
    ]);

  filterFilesInPathToList = with lib.fileset; filter: path: toList (fileFilter filter path);

  mkImportList = path: filterFilesInPathToList isValidImportFile path;

  findAllHosts =
    path: lib.forEach (filterFilesInPathToList isHostVarFile path) (path: (path + "/.."));

  mkHostAttrs =
    hosts:
    builtins.listToAttrs (
      lib.forEach hosts (
        x:
        lib.nameValuePair (builtins.baseNameOf x) {
          "hostPath" = x;
          "hostVars" = import (x + "/host-vars.nix");
        }
      )
    );

  mkHost =
    { inputs, ... }:
    hostName: attrs:
    let
      inherit (attrs.hostVars)
        system
        stateVersion
        bootstrapHost
        testHost
        ;
      inherit (attrs) hostPath;
      nixpkgs = builtins.getAttr attrs.hostVars.nixpkgs inputs;
      specialArgs = {
        inherit inputs;
        evilib = inputs.self.lib;
      };
    in
    {
      ${hostName} = nixpkgs.lib.nixosSystem {
        inherit system specialArgs;
        modules = [
          ../modules
          {
            networking.hostName = hostName;
            system.stateVersion = stateVersion;
          }
          hostPath
          ../users/${defaults.mainUser}-${hostName}
        ];
      };
    }

    // lib.optionalAttrs testHost {
      "${hostName}-test" = nixpkgs.lib.nixosSystem {
        inherit system specialArgs;
        modules = [
          ../modules
          {
            networking.hostName = "${hostName}-test";
            system.stateVersion = stateVersion;
            evilwoods.isTestEnv = true;
          }
          (hostPath + "/test.nix")
          ../users/${defaults.mainUser}-${hostName}
        ];
      };
    }

    // lib.optionalAttrs bootstrapHost {
      "${hostName}-bootstrap" = nixpkgs.lib.nixosSystem {
        inherit system specialArgs;
        modules = [
          ../modules
          {
            networking.hostName = hostName;
            system.stateVersion = stateVersion;
          }
          (hostPath + "/bootstrap.nix")
        ];
      };
    };

  mapHosts = f: hosts: lib.concatMapAttrs f hosts;

  # TODO write function to scan folder and include files
}
