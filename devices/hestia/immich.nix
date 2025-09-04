{
  config,
  lib,
  username,
  ...
}:
let
  server = config.syde.server;
  cfg = config.services.immich;
in
{

  options.services.immich = {
    mediaDir = lib.mkOption {
      type = lib.types.path;
      default = "/home/${username}/Immich";
    };
  };

  config = lib.mkIf cfg.enable {
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
      };

      nginx = {
        upstreams.immich.servers."127.0.0.1:${toString cfg.port}" = { };

        virtualHosts."photos.${server.baseDomain}".locations."/" = {
          proxyPass = "http://immich";
          proxyWebsockets = true;
          extraConfig = ''
            client_max_body_size 50000M;
            proxy_read_timeout   600s;
            proxy_send_timeout   600s;
            send_timeout         600s;
            add_header Alt-Svc 'h3=":$server_port"; ma=86400';
          '';
        };
      };
    };
  };
}
