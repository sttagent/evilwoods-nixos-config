{ inputs, config, ... }:
{
  sops = {
    defaultSopsFile = ../../secrets/secrets.yaml;
    validateSopsFiles = false;
    age = {
      sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
      keyFile = "/var/lib/sops-nix/key.txt";
      generateKey = true;
    };
  };
  
  time.timeZone = "Europe/Stockholm";
  
  services.openssh = {
    enable = true;
  };

}
