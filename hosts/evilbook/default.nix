{ evilib, ... }:
{
  imports = (evilib.scanPathForImports ./.) ++ [
    ../common/core
    ../common/desktop
    ../common/gnome

    ../common/optional/zsa.nix
  ];
}
