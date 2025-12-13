{
  pkgs ? # If pkgs is not defined, instantiate nixpkgs from locked commit
    let
      lock = (builtins.fromJSON (builtins.readFile ./flake.lock)).nodes.nixpkgs-unstable.locked;
      nixpkgs = fetchTarball {
        url = "https://github.com/nixos/nixpkgs/archive/${lock.rev}.tar.gz";
        sha256 = lock.narHash;
      };
    in
    import nixpkgs { overlays = [ (import ./overlays/pythonPackages.nix) ]; },
  ...
}:

pkgs.mkShell {
  name = "evilwoods-nixos-config";
  NIX_CONFIG = "extra-experimental-features = nix-command flakes pipe-operators";
  GIT_SSH_COMMAND = "ssh -o IdentitiesOnly=yes -o IdentityAgent=none -o UserKnownHostsFile=/dev/null";
  GIT_AUTHOR_NAME = "Arvydas Ramanauskas";
  GIT_AUTHOR_EMAIL = "711261+sttagent@users.noreply.github.com";
  GIT_COMMITTER_NAME = "Arvydas Ramanauskas";
  GIT_COMMITTER_EMAIL = "711261+sttagent@users.noreply.github.com";
  packages = with pkgs; [
    (python3.withPackages (ps: with ps; [ questionary ]))
    git
    just
    age
    ssh-to-age
    sops
    neovim
  ];
}
