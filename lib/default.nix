{ lib, ... }:
rec {
  defaults = {
    defaultSystem = "x86_64-linux";
    mainUser = "aitvaras";
  };
  
  readFilterPath = filter: path: lib.filterAttrs filter (builtins.readDir path);
  
  
  scanPathForImports = path:
  let
    filter = name: type:
        if type == "directory" then
            builtins.pathExists ./${name}/default.nix
        else
            (name != "default.nix") && lib.hasSuffix ".nix" name;
  in
  lib.mapAttrsToList (n: v: path + "/${n}") (readFilterPath filter path);
  
  # TODO write function to scan folder and include files
}
