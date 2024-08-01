{ pkgs, lib, ... }:
{
  # services.languagetool = {
  #   enable = false;
  #   public = true;
  #   port = lib.mkDefault 8081;
  #   allowOrigin = ""; # To allow access from browser addons
  # };

  virtualisation.oci-containers.containers = {
    languagetool-app = {
      autoStart = true;
      image = "meyay/languagetool:6.4";
      extraOptions = [
        "--cap-drop=ALL"
        "--cap-add=CAP_SETUID"
        "--cap-add=CAP_SETGID"
        "--cap-add=CAP_CHOWN"
        "--security-opt=no-new-privileges"
      ];
      environment = {
        download_ngrams_for_langs = "en";
        langtool_languageModel = "/ngrams";
        langtool_fasttextModel = "/fasttext/lid.176.bin";
      };
      ports = [ "8010:8010" ];
      volumes = [
        "languagetool_ngrams:/ngrams"
        "languagetool_fasttext:/fasttext"
      ];
    };
  };

  networking.firewall.allowedTCPPorts = [ 8010 ];
}
