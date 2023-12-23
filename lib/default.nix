{ lib
, ...
}: rec {
  defaultSystem = "x86_64-linux";

  # filter out null attributes
  filterNullHosts = hosts: lib.filterAttrs (name: value: value != null) hosts;

  # filter out non-nix files and directories
  fitlerMapHosts = hostDir: attrs:
    filterNullHosts (lib.mapAttrs'
      (name: value:
        let path = "${builtins.toString hostDir}/${name}"; in
        if value == "directory" && builtins.pathExists "${path}/default.nix"
        then lib.nameValuePair name (mkHost path attrs)
        else if value == "regular" &&
          name != "default.nix" &&
          lib.hasSuffix ".nix" name
        then lib.nameValuePair (lib.removeSuffix ".nix" name) (mkHost path attrs)
        else lib.nameValuePair "" null)
      (builtins.readDir hostDir));

  # make nixos system from a single nix file or directory
  mkHost = hostPath: { system ? defaultSystem, inputs, extraModules, ...}: lib.nixosSystem {
    inherit system;
    specialArgs = { inherit inputs; };
    modules = [ 
      ../modules
      ../shared-configuration
      hostPath
    ] ++ extraModules;
  };

  # make nixos systems from a directory of nix files
  mkHosts = hostDir: attrs: fitlerMapHosts hostDir attrs;
}
