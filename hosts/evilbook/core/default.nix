{ inputs, evilib, ... }:
{
  imports = (evilib.mkImportList ./.);
}
