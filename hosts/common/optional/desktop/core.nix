{ config, pkgs, ... }:
let
  mainUser = config.evilwoods.mainUser;
in
{
  boot = {
    kernelParams = [
      "quiet"
      "splash"
    ];
    plymouth.enable = true;
  };

  fonts.packages = with pkgs; [
    (nerdfonts.override {
      fonts = [
        "CommitMono"
        "SourceCodePro"
        "JetBrainsMono"
        "Hack"
      ];
    })
  ];

  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "sv_SE.UTF-8";
      LC_IDENTIFICATION = "sv_SE.UTF-8";
      LC_MEASUREMENT = "sv_SE.UTF-8";
      LC_MONETARY = "sv_SE.UTF-8";
      LC_NAME = "sv_SE.UTF-8";
      LC_NUMERIC = "sv_SE.UTF-8";
      LC_PAPER = "sv_SE.UTF-8";
      LC_TELEPHONE = "sv_SE.UTF-8";
      LC_TIME = "sv_SE.UTF-8";
    };
  };

  environment.variables = {
    NIXOS_OZONE_WL = "1";
  };

  zramSwap.enable = true;

  # Recommended for pipwire
  security.rtkit.enable = true;
  security.pam.services.${mainUser}.enableGnomeKeyring = true;

  # Needs to be disabled if using pipwire
  hardware.pulseaudio.enable = false;

  programs = {
    xwayland.enable = true;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
  };

  services = {
    flatpak.enable = true;
    fstrim.enable = true;
    pcscd.enable = true;
    # Enable the X11 windowing system.
    xserver = {
      enable = true;
      displayManager.gdm.enable = true;
    };

    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
    };

    udev = {
      packages = [ pkgs.yubikey-personalization ];
      extraRules = ''
        # Bitbox udev rules
        SUBSYSTEM=="usb", SYMLINK+="bitbox02_%n", GROUP="plugdev", MODE="0664", ATTRS{idVendor}=="03eb", ATTRS{idProduct}=="2403"
        KERNEL=="hidraw*", SUBSYSTEM=="hidraw", SYMLINK+="bitbox02_%n", GROUP="plugdev", MODE="0664", ATTRS{idVendor}=="03eb", ATTRS{idProduct}=="2403"
        SUBSYSTEM=="usb", SYMLINK+="dbb%n", GROUP="plugdev", MODE="0664", ATTRS{idVendor}=="03eb", ATTRS{idProduct}=="2402"
        KERNEL=="hidraw*", SUBSYSTEM=="hidraw", SYMLINK+="dbbf%n", GROUP="plugdev", MODE="0664", ATTRS{idVendor}=="03eb", ATTRS{idProduct}=="2402"
      '';
    };
  };
}
