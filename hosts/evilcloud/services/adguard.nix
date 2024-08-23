{
  services.adguardhome = {
    enable = true;
    settings = {
      http.address = "127.0.0.1:3000";
    };
  };
}