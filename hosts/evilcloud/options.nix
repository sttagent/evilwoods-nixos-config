{ lib, ... }:
let
  inherit (lib) mkOption types;
in
{
  options = {
    evilwoods.host = {
      storagePath = mkOption {
        type = types.str;
        default = "/var/storage";
        description = ''
          Path to the directory where the all data will be stored.
        '';
      };

      dataPath = mkOption {
        type = types.str;
        default = "/var/storage/data";
        description = ''
          Path to the directory where the service data will be stored.
        '';
      };

      legoHTTPPort = mkOption {
        type = types.int;
        default = 1360;
        description = ''
          Port to listen on for HTTP requests.
        '';
      };
    };

  };
}
