{
  services.ntfy-sh = {
    enable = true;
    settings = {
      listen-http = ":8080";
      base-url = "https://evilserver";
    };
  };
}
