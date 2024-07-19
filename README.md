# Evilwoods NixOS Config

This is my personal NixOS configuration.

Hosts:
- `evilbook` - My personal laptop
- `evilcloud` - My personal home server

## Notes

### Clone git repo using residential keys

```bash
git -c core.sshCommand='ssh -o StrictHostKeyChecking=accept-new -o IdentityAgent=none -i .ssh/id_ed25519_sk_rk_yubikey2' clone git@github.com:sttagent/evilwoods-nixos-config.git
```
