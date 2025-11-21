{ evilib, ... }:
let
  inherit (evilib) mkImportList;
in
{

  imports = [ ../admin ] ++ (mkImportList ./.);
}
