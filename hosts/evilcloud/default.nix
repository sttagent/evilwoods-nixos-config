{
  modulesPath,
  evilib,
  inputs,
  ...
}:
{
  imports = (evilib.mkImportList ./.);
}
