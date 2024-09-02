{ inputs, ... }:
let
  lib = inputs.nixpkgs-unstable.legacyPackages."x86_64-linux".lib;
in
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

  mkHostTest =
    inputs: hostName: attrs:
    let
      inherit (attrs) hostPath;
      inherit (attrs.hostVars) system testHost;
      nixpkgs = builtins.getAttr attrs.hostVars.nixpkgs inputs;
      pkgs = nixpkgs.legacyPackages."${system}";
    in
    if testHost then
      {
        "${hostName}-test" = pkgs.testers.runNixOSTest (
          import (hostPath + "/test.nix") { inherit inputs; }
        );
      }
    else
      { };

  mkHost =
    { inputs, ... }:
    hostName: attrs:
    let
      inherit (attrs.hostVars) system bootstrapHost;
      inherit (attrs) hostPath;
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
          hostPath
          ../users/${defaults.mainUser}-${hostName}
        ];
      };
    }

    // lib.optionalAttrs bootstrapHost {
      "${hostName}-bootstrap" = nixpkgs.lib.nixosSystem {
        inherit system specialArgs;
        modules = [
          ../modules
          { networking.hostName = hostName; }
          (hostPath + "/bootstrap.nix")
        ];
      };
    };

  mapHosts = f: hosts: lib.concatMapAttrs f hosts;

  # TODO write function to scan folder and include files
}
