{ inputs, ... }:
let
  lib = inputs.nixpkgs-unstable.legacyPackages."x86_64-linux".lib;

  inherit (builtins)
    baseNameOf
    filter
    elem
    readFile
    fromTOML
    listToAttrs
    map
    head
    ;

  inherit (lib)
    hasSuffix
    nameValuePair
    concatMapAttrs
    optionalAttrs
    splitString
    ;

  inherit (lib.filesystem) listFilesRecursive;

in
rec {
  readInVarFile = path: path |> readFile |> fromTOML;

  mkImportList =
    path:
    path
    |> listFilesRecursive
    |> filter (filePath: hasSuffix ".nix" (baseNameOf filePath))
    |> filter (
      filePath:
      !elem (baseNameOf filePath) [
        "default.nix"
        "test.nix"
      ]
    );

  mkUserImportList =
    path:
    let
      userName = baseNameOf path |> splitString "-" |> head;
      applyUserName = file: import file userName;
    in
    path |> mkImportList |> map applyUserName;

  findAllHosts =
    hostsPath:
    let
      isHostVarFile = path: path |> baseNameOf |> toString |> hasSuffix ".toml";
    in
    filter isHostVarFile (listFilesRecursive hostsPath);

  mkHostAttrs =
    # reads the toml file with the same name as host in host folder
    # and make an attrset with host vars
    let
      mkAttr =
        path:
        nameValuePair (path |> dirOf |> baseNameOf) {
          hostPath = dirOf path;
          inherit (path |> readFile |> fromTOML)
            system
            channel
            mainUser
            makeTestHost
            extraUsers
            ;
        };
    in
    hostVarFilePathList: hostVarFilePathList |> map mkAttr |> listToAttrs;

  mkHost =
    commonNixOSModules: hostName: attrs:
    let
      inherit (attrs)
        hostPath
        system
        mainUser
        channel
        makeTestHost
        extraUsers
        ;
      nixpkgs = builtins.getAttr channel inputs;
      specialArgs = {
        inherit inputs;
        evilib = inputs.self.lib;
        configPath = inputs.self.outPath + "/hosts/config";
        dotFilesPath = inputs.self.outPath + "/dotfiles";
        resourcesPath = inputs.self.outPath + "/resources";
      };
      commonModules = [
        ../modules
        ../hosts/common
        ../users/common
        ../users/${mainUser}-${hostName}
        hostPath
        {
          nixpkgs.hostPlatform = system;
          evilwoods.base.mainUser = mainUser;
        }
      ]
      ++ (map (user: ../users/${user}-${hostName}) extraUsers);
    in
    {
      ${hostName} = nixpkgs.lib.nixosSystem {
        inherit specialArgs;
        modules =
          commonModules
          ++ commonNixOSModules
          ++ [
            {
              networking.hostName = "${hostName}";
            }
          ];
      };
    }
    // optionalAttrs makeTestHost {
      ${hostName + "-vm-test"} = nixpkgs.lib.nixosSystem {
        inherit specialArgs;
        modules = commonModules ++ [
          {
            networking.hostName = "${hostName}-vm-test";
            evilwoods.testEnv.enabled = true;
            evilwoods.vmGuest.enabled = true;
          }
        ];
      };
    };

  mkHosts =
    commonNixOSModules: hostsPath:
    concatMapAttrs (mkHost commonNixOSModules) (mkHostAttrs (findAllHosts hostsPath));
}
