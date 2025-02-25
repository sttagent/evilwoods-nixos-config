# Evilwoods NixOS Config

This is my personal very much work in progress NixOS configuration.

## Folder Structure

### dotfiles

Various configuration files managed by home-manager I was not able to configure through home-manager module system.

### Hosts

NixOS system configuration folder.

Hosts:

- `evilbook` - laptop
- `evilserver` - home server (currently not used)
- `evilcloud` - server

### scripts

Various helper scripts specific to this configuration.

## Notes

### Installation notes

- clone repo with custom ssh command.

```bash
GIT_SSH_COMMAND="ssh -i ~/.ssh/id_ed25519_sk_rk_yubikey2 -o IdentityAgent=none" \
git clone git@github.com:sttagent/evilwoods-nixos-config.gita && \
GIT_SSH_COMMAND="ssh -i ~/.ssh/id_ed25519_sk_rk_yubikey2 -o IdentityAgent=none" \
git clone git@github.com:sttagent/evilwoods-nixos-config-secrets.git
```

- Setup host ssh keys.
  - Generate new ones with the script in secrets repo or point to old ones
  - Update re-encrypt sops secrets
- Install nixos using the script in the config repo
