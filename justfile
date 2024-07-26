default:
    just --list

refresh:
    nix flake update --commit-lock-file
    
switch host="":
    nixos-rebuild switch --flake .#{{host}} --use-remote-sudo {{ if host == "" { "" } else { "--target-host " + host } }}

boot host="":
    nixos-rebuild boot --flake .#{{host}} --use-remote-sudo {{ if host == "" { "" } else { "--target-host " + host } }}

reboot host:
  ssh -t {{host}} "sudo systemctl reboot"

build host="":
    nixos-rebuild build --flake .#{{host}} |& nom

upgrade:
    just refresh boot
    
diff:
    nvd diff /run/current-system ./result/

format-disk host:
    sudo nix --extra-experimental-features "nix-command flakes" run github:nix-community/disko -- --mode disko --flake .#{{host}}

gen-ssh-keys:
    sudo mkdir -p /mnt/etc/ssh
    sudo ssh-keygen -A -f /mnt

gen-age-pub-key host:
    #!/usr/bin/env bash
    age_pub_key=$(ssh-to-age -i /mnt/etc/ssh/ssh_host_ed25519_key.pub)
    sed "s/\(^ \+- &{{host}} \).*/\1$age_pub_key/" -i .sops.yaml
    sops updatekeys -y ./secrets/secrets.yaml

gen-age-pub-key-local host:
    #!/usr/bin/env bash
    age_pub_key=$(ssh-to-age -i /etc/ssh/ssh_host_ed25519_key.pub)
    sed "s/\(^ \+- &{{host}} \).*/\1$age_pub_key/" -i .sops.yaml
    sops updatekeys -y ./secrets/secrets.yaml

save-age-key username password:
    #!/usr/bin/env bash
    mkdir -p ~/.config/sops/age/
    touch ~/.config/sops/age/keys.txt
    session_key=$(bw login {{username}} {{password}} --raw)
    bw get password evilwoods-nixos-sops --session "$session_key" | tee ~/.config/sops/age/keys.txt

install-nixos host:
    sudo nixos-install --no-root-password --flake .#{{host}}

setup-nixos host username password:
    just config-env
    just format-disk {{host}}
    just gen-ssh-keys
    just save-age-key {{username}} {{password}}
    just gen-age-pub-key {{host}}
    just install-nixos {{host}}


config-env:
    #!/usr/bin/env bash
    echo | tee ~/.ssh/config <<- EndOfMessage
    Host *
        IdentitiesOnly yes
        IdentityAgent none
        IdentityFile ~/.ssh/id_ed25519_sk_rk_yubikey2
    EndOfMessage
    git config user.name "Arvydas Ramanauskas"
    git config user.email "711261+sttagent@users.noreply.github.com"

install-nixos-to-remote host-config remote-user-host:
  nix run github:nix-community/nixos-anywhere -- --flake '.#{{host-config}}' {{remote-user-host}}

