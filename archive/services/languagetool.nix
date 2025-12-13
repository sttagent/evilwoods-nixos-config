# This file contains configuration for the languagetool service.
# It spins up a container image.
{ config, lib, ... }:
let
  inherit (config.evilwoods.host.vars) dataPath;
  inherit (config.evilwoods.vars) domain;

  appName = "languagetool";
  languagetoolDataPath = "${dataPath}/${appName}";
  languagetoolUrl = "languagetool.${domain}";

  legoListenHTTP = "1360";

in
{
  systemd.tmpfiles.rules = [
    "d ${languagetoolDataPath}/ngrams 755 root root"
    "d ${languagetoolDataPath}/fasttext 755 root root"
  ];
  virtualisation.oci-containers.containers = {
    "${appName}" = {
      autoStart = true;
      image = "meyay/languagetool:6.5";
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
        "${languagetoolDataPath}/ngrams:/ngrams"
        "${languagetoolDataPath}/fasttext:/fasttext"
      ];
    };
  };

  services.caddy.virtualHosts."${languagetoolUrl}" = {
    useACMEHost = "${languagetoolUrl}";
    extraConfig = ''
      reverse_proxy http://localhost:8010
    '';
  };

  security.acme.certs.${languagetoolUrl} = {
    domain = languagetoolUrl;
    listenHTTP = ":${legoListenHTTP}";
    reloadServices = [ "caddy.service" ];
  };
}
