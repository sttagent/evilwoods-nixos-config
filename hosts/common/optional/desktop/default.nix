{ evilib, ... }:
let
  inherit (evilib) mkImportList;
in {
  imports = mkImportList ./.;
}
