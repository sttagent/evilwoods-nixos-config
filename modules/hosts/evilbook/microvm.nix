{ inputs, lib, ... }:
{
  flake.modules.nixos.microvms =
    { config, ... }:
    let
      vmName = "opencodevm";
      userName = "aitvaras";
    in
    {
      imports = [ inputs.microvm.nixosModules.host ];

      systemd.network = {
        enable = true;
        netdevs."20-microbr".netdevConfig = {
          Kind = "bridge";
          Name = "microbr";
        };
        networks = {
          "20-microbr" = {
            matchConfig.Name = "microbr";
            networkConfig = {
              ConfigureWithoutCarrier = true;
            };
            addresses = [ { Address = "10.0.0.1/24"; } ];
          };

          "21-microvm-tap" = {
            matchConfig.Name = "microvm*";
            networkConfig.Bridge = "microbr";
          };
        };

      };

      networking = {
        firewall.trustedInterfaces = [ "microbr" ];
        useNetworkd = true;
        nat = {
          enable = true;
          internalInterfaces = [ "microbr" ];
          externalInterface = "wlan0";
        };
      };

      microvm.vms.${vmName} = {
        pkgs = inputs.nixpkgs.legacyPackages."x86_64-linux";
        autostart = false;
        config =
          { pkgs, ... }:
          {
            imports = [
              inputs.microvm.nixosModules.microvm
            ];
            system.stateVersion = "26.05";

            environment.systemPackages = with pkgs; [
              opencode
              git
              jujutsu
            ];

            programs.fish.enable = true;

            services = {
              resolved.enable = true;
              openssh = {
                enable = true;
                hostKeys = [
                  {
                    path = "/etc/ssh/host_keys/ssh_host_ed25519_key";
                    type = "ed25519";
                  }
                ];
              };

            };
            networking = {
              useNetworkd = true;
              useDHCP = false;
              firewall.enable = false;
              tempAddresses = "disabled";
              hostName = "${vmName}";
              nameservers = [
                "8.8.8.8"
                "1.1.1.1"
              ];
            };

            systemd = {
              network = {
                enable = true;
                networks."10-e" = {
                  # matchConfig.Name = "e*";
                  matchConfig.MACAddress = "02:00:00:00:00:01";
                  addresses = [ { Address = "10.0.0.10/24"; } ];
                  routes = [ { Gateway = "10.0.0.1"; } ];
                };
              };

              mounts = [
                {
                  what = "store";
                  where = "/nix/store";
                  overrideStrategy = "asDropin";
                  unitConfig.DefaultDependencies = false;
                }
              ];
              tmpfiles.rules = [
                "d /home/${userName}/.config 755 ${userName} users"
                "d /home/${userName}/.local 755 ${userName} users"
                "d /home/${userName}/.local/share 755 ${userName} users"
                "d /home/${userName}/.local/state 755 ${userName} users"
              ];
            };

            users.users = {
              aitvaras = {
                isNormalUser = true;
                description = "Arvydas Ramanauskas";
                password = "password1";
                extraGroups = [
                  "wheel"
                ]; # Enable ‘sudo’ for the user.
                shell = pkgs.fish;
                openssh.authorizedKeys.keys = [
                  "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGFc8oFtu7i4WBlbcDMB7ua9cHJW2bzeomrLFddokw7v aitvaras@evilbook"
                ];
              };

            };

            microvm = {
              hypervisor = "cloud-hypervisor";
              vcpu = 4;
              mem = 1024 * 4;
              socket = "control.socket";
              volumes = [
                {
                  mountPoint = "/var";
                  image = "var.img";
                  size = 8192; # MB
                }
              ];
              writableStoreOverlay = "/nix/.rw-store";
              shares = [
                {
                  proto = "virtiofs";
                  tag = "ro-store";
                  source = "/nix/store";
                  mountPoint = "/nix/.ro-store";
                }
                {
                  proto = "virtiofs";
                  tag = "ssh-keys";
                  source = "/home/aitvaras/microvms/opencodevm/host_keys";
                  mountPoint = "/etc/ssh/host_keys";
                }
                {
                  proto = "virtiofs";
                  tag = "opencode-config";
                  source = "/home/aitvaras/.config/opencode";
                  mountPoint = "/home/aitvaras/.config/opencode";
                }
                {
                  proto = "virtiofs";
                  tag = "opencode-data";
                  source = "/home/aitvaras/.local/share/opencode";
                  mountPoint = "/home/aitvaras/.local/share/opencode";
                }
                {
                  proto = "virtiofs";
                  tag = "opencode-state";
                  source = "/home/aitvaras/.local/state/opencode";
                  mountPoint = "/home/aitvaras/.local/state/opencode";
                }
                # {
                #   proto = "virtiofs";
                #   tag = "claude-credentials";
                #   source = "/home/michael/claude-microvm";
                #   mountPoint = "/home/michael/claude-microvm";
                # }
                {
                  proto = "virtiofs";
                  tag = "workspace";
                  source = "/home/aitvaras/microvms/opencodevm/data";
                  mountPoint = "/home/aitvaras/microvms/opencodevm/data";
                }
              ];
              interfaces = [
                {
                  type = "tap";
                  id = "microvm10";
                  mac = "02:00:00:00:00:01";
                }
              ];
            };
          };
      };
    };
}
