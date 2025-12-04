{ config, pkgs, ... }:
let
  inherit (config.syde) server;
  inherit (server) baseDomain;

  certsDirectory = config.security.acme.certs."auth.${baseDomain}".directory;
in
{
  services = {
    kanidm = {
      enableServer = true;

      package = pkgs.kanidm_1_8;

      serverSettings = {
        bindaddress = "0.0.0.0:8443";
        ldapbindaddress = "0.0.0.0:636";

        domain = "auth.${baseDomain}";
        origin = "https://auth.${baseDomain}";

        tls_chain = "${certsDirectory}/fullchain.pem";
        tls_key = "${certsDirectory}/key.pem";
      };

      enableClient = true;
      clientSettings.uri = "https://auth.${baseDomain}";
    };

    nginx = {
      upstreams.kanidm.servers."127.0.0.1:8443" = { };

      virtualHosts."auth.${baseDomain}".locations."/" = {
        proxyPass = "https://kanidm";
        proxyWebsockets = true;
      };
    };
  };

  systemd.services.kanidm = {
    after = [ "acme-auth.${baseDomain}.service" ];
    serviceConfig.SupplementaryGroups = [ "acme" ];
  };

  security.acme.certs."auth.${baseDomain}".reloadServices = [ "kanidm.service" ];

  networking.firewall.allowedTCPPorts = [ 636 ];
}
