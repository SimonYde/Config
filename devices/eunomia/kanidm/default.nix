{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.services.kanidm;

  inherit (config.syde) server;
  inherit (server) authDomain;

  certsDirectory = config.security.acme.certs.${authDomain}.directory;
in
{
  imports = [ ./kanidm-mail-sender.nix ];

  config = lib.mkIf cfg.server.enable {
    services = {
      kanidm = {
        package = pkgs.kanidm_1_11;

        server.settings = {
          bindaddress = "0.0.0.0:8443";
          ldapbindaddress = "0.0.0.0:636";

          domain = authDomain;
          origin = "https://${authDomain}";

          tls_chain = "${certsDirectory}/fullchain.pem";
          tls_key = "${certsDirectory}/key.pem";
        };

        client = {
          enable = true;
          settings.uri = "https://${authDomain}";
        };
      };

      nginx = {
        upstreams.kanidm.servers."127.0.0.1:8443" = { };

        virtualHosts.${authDomain}.locations."/" = {
          proxyPass = "https://kanidm";
          proxyWebsockets = true;
        };
      };
    };

    systemd.services.kanidm = {
      after = [ "acme-${authDomain}.service" ];
      serviceConfig.SupplementaryGroups = [ "acme" ];
    };

    security.acme.certs.${authDomain}.reloadServices = [ "kanidm.service" ];

    networking.firewall.allowedTCPPorts = [ 636 ];
  };
}
