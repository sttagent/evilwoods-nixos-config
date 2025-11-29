{ evilib, ... }:
let
  inherit (evilib) mkImportList;
in
{
  imports = [ ../aitvaras ] ++ (mkImportList ./.);
}
