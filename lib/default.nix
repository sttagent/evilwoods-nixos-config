{ lib
, ...
}: rec {
  defaultSystem = "x86_64-linux";

  mkPkgs = { channel, system ? defaultSystem, cfg ? { allowUnfree = true; } }:
    import channel {
      inherit system;
      config = cfg;
    };

  # filter out null attributes
  filterNullHosts = hosts: lib.filterAttrs (name: value: value != null) hosts;

  # filter out non-nix files and directories
  fitlerMapHosts = fn: hostDir:
    filterNullHosts (lib.mapAttrs'
      (name: value:
        let path = "${hostDir}/${name}"; in
        if value == "directory" && builtins.pathExists "${path}/default.nix"
        then lib.nameValuePair name (fn path)
        else if value == "regular" &&
          name != "default.nix" &&
          lib.hasSuffix ".nix" name
        then lib.nameValuePair (lib.removeSuffix ".nix" name) (fn path)
        else lib.nameValuePair "" null)
      (builtins.readDir hostDir));

  mkHost = hostPath: hostPath;

  # make nixos systems from a directory of nix files
  mkHosts = hostDir: attrs: fitlerMapHosts mkHost hostDir;
}
