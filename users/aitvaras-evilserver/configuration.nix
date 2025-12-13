currentUser:
{
  inputs,
  ...
}:
let
  secretsPath = builtins.toString inputs.evilsecrets;
in
{
  imports = [ ../aitvaras ];

  sops.secrets.ssh-pub-key = {
    sopsFile = "${secretsPath}/secrets/aitvaras/default.yaml";
    neededForUsers = true;
  };

  users.users = {
    ${currentUser}.openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGFc8oFtu7i4WBlbcDMB7ua9cHJW2bzeomrLFddokw7v aitvaras@evilbook"
    ];
  };
}
