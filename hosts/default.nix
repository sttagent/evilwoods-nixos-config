{ inputs, ... }:
let
  evilib = inputs.self.lib;
in
with evilib;
mapHosts (mkHost { inherit inputs; }) (mkHostAttrs (findAllHosts ./.))
