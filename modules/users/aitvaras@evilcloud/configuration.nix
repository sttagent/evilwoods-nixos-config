{
  self,
  inputs,
  ...
}:
let
  secretsPath = builtins.toString inputs.evilsecrets;
in
{
  flake.modules.nixos."userAitvaras@evilcloud" =
    { pkgs, ... }:
    let
      currentUser = "aitvaras";
    in
    {
      imports = [ self.modules.nixos.userAitvaras ];

      sops.secrets.ssh-pub-key = {
        sopsFile = "${secretsPath}/secrets/aitvaras/default.yaml";
        neededForUsers = true;
      };

      users.users = {
        ${currentUser}.openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGFc8oFtu7i4WBlbcDMB7ua9cHJW2bzeomrLFddokw7v aitvaras@evilbook"
        ];
      };

      home-manager = {
        sharedModules = [
          inputs.sops-nix-2511.homeManagerModules.sops
        ];

        users.${currentUser} = {
          programs = {
            home-manager.enable = true;
          };
        };
      };
    };
}
