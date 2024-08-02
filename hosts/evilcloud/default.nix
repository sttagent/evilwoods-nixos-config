{ modulesPath, evilib, ... }:
{
  imports = (evilib.scanPathForImports ./.) ++ [
    (modulesPath + "/installer/scan/not-detected.nix")
    (modulesPath + "/profiles/qemu-guest.nix")

    ../common/core
  ];
}
