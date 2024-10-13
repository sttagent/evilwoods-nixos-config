{ inputs, ... }:
let
  lib = inputs.nixpkgs-unstable.legacyPackages."x86_64-linux".lib;

  inherit (builtins)
    baseNameOf
    filter
    elem
    ;

  inherit (lib)
    hasSuffix
    ;

  inherit (lib.filesystem) listFilesRecursive;

in
{

  mkImportList =
    # Scan dir for all files recusevily that have .nix suffix and are not default file.
    path:
    let
      isValidImportFile =
        filePath:
        let
          fileName = baseNameOf filePath;
        in
        (hasSuffix ".nix" fileName)
        && !(elem fileName [
          "default.nix"
          "host-vars.nix"
          "test.nix"
        ]);
    in
    filter isValidImportFile (listFilesRecursive path);
}
