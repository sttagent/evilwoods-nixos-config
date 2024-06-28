{ config, ... }:
let
  inherit (import ../aitvaras/vars.nix) thisUser;
in
{
  imports = [
    ../aitvaras
  ];

  sops.secrets.ssh-pub-key.neededForUrers = true;

  users.users = {
    ${thisUser}.openssh.authrizedKeys.keyFiles = [
      config.sops.secrets.ssh-pub-key.path
    ];
  };
}
