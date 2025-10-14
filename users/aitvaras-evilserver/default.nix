{ evilib, config, ... }:
let
  inherit (evilib.readInVarFile ../aitvaras/vars.toml) currentUser;
in
{
  imports = [ ../aitvaras ];

  sops.secrets.ssh-pub-key.neededForUsers = true;

  users.users = {
    ${currentUser}.openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGFc8oFtu7i4WBlbcDMB7ua9cHJW2bzeomrLFddokw7v aitvaras@evilbook"
    ];
  };
}
