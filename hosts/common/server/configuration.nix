{ config, lib, ... }:
let
  inherit (lib) mkIf;
  isServer = config.evilwoods.vars.role == "server";
in
{
  config = mkIf isServer {
  };
}
