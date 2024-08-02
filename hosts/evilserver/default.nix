{ evilib, ... }:
{
  imports = (evilib.scanPathForImports ./.) ++ [
    ../common/core
  ];
}
