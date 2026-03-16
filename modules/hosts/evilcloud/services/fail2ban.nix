{ ... }:
{
  flake.modules.nixos.serviceFail2ban = {
    services.fail2ban = {
      enable = true;
      ignoreIP = [ "100.64.0.0/10" ];
    };
  };
}
