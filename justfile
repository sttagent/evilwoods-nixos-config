default:
    just --list

init-shell:
    nix shell nixpkgs#just nixpkgs#gum --experimental-features 'nix-command flakes'

refresh:
    nix flake update --commit-lock-file
    
switch:
    nixos-rebuild switch --use-remote-sudo

boot:
    nixos-rebuild boot --use-remote-sudo

build:
    nixos-rebuild build 

upgrade:
    just refresh boot
    
diff:
    nix store diff-closures ./result /run/current-system