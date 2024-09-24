{
  services.ntfy-sh = {
    enable = false;
    settings = {
      listen-http = ":8080";
      base-url = "https://ntfy.evilwoods.net";
    };
  };
}
