{
  services = {
    atuin = {
      enable = true;
      host = "0.0.0.0";
      openRegistration = true;
    };

    # postgresqlBackup = {
    #   databases = [ "atuin" ];
    # };
  };
}
