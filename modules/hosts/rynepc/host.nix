{ inputs, ... }: {
  den.hosts.x86_64-linux.rynepc = {
    stateVersion = "25.11";
    mainUser = "admin";
    users = {
      admin = { };
      rynepc = { };
    };
  };

  den.aspects.rynepc.nixos = {
    imports = with inputs; [
      disko.nixosModules.disko
      sops-nix.nixosModules.default
    ];
  };
}
