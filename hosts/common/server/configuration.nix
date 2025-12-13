{ config, lib, ... }:
let
  inherit (lib) mkIf;
  isServer = config.evilwoods.flags.role == "server";
in
{
  config = mkIf isServer {
    users.users.root.openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGFc8oFtu7i4WBlbcDMB7ua9cHJW2bzeomrLFddokw7v aitvaras@evilbook"
    ];
  };
}
