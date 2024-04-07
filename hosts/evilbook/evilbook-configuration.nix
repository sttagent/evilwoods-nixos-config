{ config, lib, pkgs, ... }:
let
  mainUser = config.evilcfg.mainUser;
in
{
  evilcfg.enableGnome = true;
  #evilcfg.steam = true;
  evilcfg.zsa = true;
  evilcfg.podman = true;
  # evilcfg.docker = true;
  # evilcfg.libvirtd = true;
  # evilcfg.enableHyprland = true;

  boot = {
    initrd = {
      verbose = false;
    };

    loader = {
      efi = {
        canTouchEfiVariables = true;
      };
      systemd-boot.enable = true;
    };
  };

  programs.nix-ld = {
    enable = true;
  };

  # LTU VPN
  # services.strongswan.enable = true;
  # networking.networkmanager.enableStrongSwan = true;


  # networking.interfaces.enp3s0.useDHCP = lib.mkDefault true;

  # sops.defaultSopsFile = ../../secrets/secrets.yaml;
  # sops.defaultSopsFormat = "yaml";
  # sops.secrets.example-key = { };
  # sops.secrets."myservice/my_subdir/my_secret" = { };
  # sops.age.keyFile = /home/${mainUser}/.config/sops/age/keys.txt;
  # sops.gnupg.sshKeyPaths = [ ];

  # Version of NixOS installed from live disk. Needed for backwards compatability.
  system.stateVersion = "24.05"; # Did you read the comment?
}
