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
  packages = with pkgs; [
    git
    just
    age
    ssh-to-age
    sops
    bitwarden-cli
    neovim
    nixd
    cachix
    nix-output-monitor
    nvd
    nixfmt-rfc-style
    ssh-to-age
    sops
    jq
    python312Packages.python-lsp-server
    lua-language-server
    nixos-option
    nix-tree
  ];
}
