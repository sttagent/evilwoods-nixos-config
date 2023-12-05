{
  lib,
  ...
}: rec {
  defaultSystem = "x86_64-linux";

  mkPkgs = { channel, system ? defaultSystem, cfg ? { allowUnfree = true; } }:
    import channel {
      inherit system;
      config = cfg;
    };

  mkHosts = hostsDir: 
    lib.filterAttrs (name: value:
      value != null)
    (lib.mapAttrs' (name: value:
      let path = "${hostsDir}/${name}"; in
      if value == "directory" && builtins.pathExists "${path}/default.nix"
      then lib.nameValuePair name value
      else if value == "regular" && 
              name != "default.nix" &&
              lib.hasSuffix ".nix" name
      then lib.nameValuePair (lib.removeSuffix ".nix" name) value
      else lib.nameValuePair "" null)
    (builtins.readDir hostsDir));
}
