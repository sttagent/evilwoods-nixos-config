{ config, inputs, evilib, ... }:
let
  mainUser = config.evilwoods.mainUser;
  secretsPath = builtins.toString inputs.evilsecrets;
in
{
  imports = evilib.mkImportList ./.;
  sops = {
    defaultSopsFile = "${secretsPath}/secrets.yaml";
    validateSopsFiles = false;
    age = {
      sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
      keyFile = "/var/lib/sops-nix/key.txt";
      generateKey = true;
    };
  };

}
