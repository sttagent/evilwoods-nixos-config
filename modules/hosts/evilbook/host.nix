{ inputs, ... }:
{
  den.hosts.x86_64-linux.evilbook = {
    stateVersion = "26.11";
    mainUser = "aitvaras";
    users.aitvaras = { };
  };

  den.aspects.evilbook.nixos = {
    imports = with inputs; [
      disko.nixosModules.disko
      sops-nix.nixosModules.default
    ];
  };

}
