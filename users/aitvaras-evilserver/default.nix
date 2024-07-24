{ config, ... }:
let
  inherit (import ../aitvaras/vars.nix) thisUser;
in
{
  imports = [
    ../aitvaras
  ];

  sops.secrets.ssh-pub-key.neededForUsers = true;

  users.users = {
    ${thisUser}.openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGFc8oFtu7i4WBlbcDMB7ua9cHJW2bzeomrLFddokw7v aitvaras@evilbook"
    ];
  };
}
