default:
    just --list

refresh:
    nix flake update --commit-lock-file
    
switch:
    nixos-rebuild switch --use-remote-sudo

boot:
    nixos-rebuild boot --use-remote-sudo

build:
    nixos-rebuild build |& nom

upgrade:
    just refresh boot
    
diff:
    nvd diff /run/current-system ./result/
