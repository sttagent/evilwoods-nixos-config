{
  services.fail2ban = {
    enable = true;
    ignoreIP = [ "100.64.0.0/10" ];
  };
}
