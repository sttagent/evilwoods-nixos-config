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
{
  default = pkgs.mkShell {
    name = "evilwoods-nixos-config-env";
    NIX_CONFIG = "extra-experimental-features = nix-command flak";
    nativeBuildInputs = with pkgs; [
      fish
      xonsh
      nix
      home-manager
      git
      just
      age
      ssh-to-age
      sops
      bitwarden-cli
      neovim
    ];

    shellHook = ''
      exec xonsh
    '';
  };
}
