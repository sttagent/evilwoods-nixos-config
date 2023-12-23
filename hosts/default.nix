{ inputs, extraModules ? [], ...}: 
let
  evilib = import ../lib { inherit (inputs.nixpkgs-unstable) lib; };
in evilib.mkHosts ./. { inherit inputs extraModules; }
