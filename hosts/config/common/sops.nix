{ inputs, ... }:
let
  secretsPath = builtins.toString inputs.evilsecrets;
in
{
  sops = {
    defaultSopsFile = "${secretsPath}/secrets/default.yaml";
    validateSopsFiles = false;
    age = {
      sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
      keyFile = "/var/lib/sops-nix/key.txt";
      generateKey = true;
    };
  };
}
