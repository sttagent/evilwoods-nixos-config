{ inputs, ... }:
let
  lib = inputs.nixpkgs-unstable.legacyPackages."x86_64-linux".lib;

  inherit (builtins)
    baseNameOf
    filter
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
        && (fileName != "default.nix")
        && (fileName != "host-vars.nix")
        && (fileName != "test.nix");
    in
    filter isValidImportFile (listFilesRecursive path);
}
