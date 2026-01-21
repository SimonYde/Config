{
  config,
  lib,
  inputs,
  ...
}:
let
  inherit (lib) mkForce;
  inherit (config.syde) server;
  cfg = config.services.immich;
in
{

  options.services.immich = {
    mediaDir = lib.mkOption {
      type = lib.types.path;
    };
  };

  config = lib.mkIf cfg.enable {
    age.secrets.immichClientSecret = {
      file = "${inputs.secrets}/immichClientSecret.age";
      owner = "grafana";
    };
    systemd.tmpfiles.rules = [ "d ${cfg.mediaDir} 0775 immich ${server.group} - -" ];

    users.users.immich.extraGroups = [
      "video"
      "render"
    ];

    services = {
      immich = {
        inherit (server) group;

        database = {
          enableVectors = false;
          enableVectorChord = true;
        };

        port = 2283;
        mediaLocation = "${cfg.mediaDir}";

        settings = {
          oauth = {
            enabled = true;
            clientId = "immich";
            buttonText = "Login with Kanidm";
            issuerUrl = "https://auth.simonyde.com/oauth2/openid/immich";
            clientSecret._secret = config.age.immichClientSecret.path;
          };
        };
      };

      nginx = {
        upstreams.immich.servers."${cfg.host}:${toString cfg.port}" = { };

        # virtualHosts."photos.${server.baseDomain}" = {
        virtualHosts."photos.ts.simonyde.com" = {
          acmeRoot = mkForce null;
          enableACME = mkForce false;
          useACMEHost = "ts.simonyde.com";

          locations."/" = {
            proxyPass = "http://immich";
            proxyWebsockets = true;
            extraConfig = ''
              client_max_body_size 50000M;
              proxy_read_timeout   600s;
              proxy_send_timeout   600s;
              send_timeout         600s;
            '';
          };
        };
      };
    };
  };
}
