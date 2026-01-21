{
  config,
  lib,
  ...
}:

let
  inherit (config.syde) server;
  cfg = config.services.collabora-online;
in
{
  services = {
    collabora-online = {
      enable = true;
      port = 9980;
      extraArgs = [
        "--o:net.lok_allow.host[14]=opencloud.ts.simonyde.com"
      ];

      aliasGroups = [
        {
          host = "cloud.${server.baseDomain}";
        }
        {
          host = "wopi.ts.simonyde.com";
        }
      ];

      settings = {
        storage.wopi = {
          "@allow" = true;

          alias_groups = {
            "@mode" = "groups";
          };

          host = ["cloud.${server.baseDomain}"];
        };

        # Listen on loopback interface only
        net = {
          post_allow.host = [
            ''127\.0\.0\.1''
          ];
          content_security_policy = "frame-ancestors 'self' docs.tmcs.dk opencloud.ts.simonyde.com";
        };

        server_name = "docs.${server.baseDomain}";

        ssl = {
          enable = false;
          termination = true;
        };
      };
    };

    nginx = {
      upstreams.collabora.servers."127.0.0.1:${toString cfg.port}" = { };

      virtualHosts."docs.${server.baseDomain}" = {
        locations."/" = {
          proxyPass = "http://collabora";
          proxyWebsockets = true;
        };
      };
    };
  };

  systemd.services.nextcloud-config-collabora =
    let
      inherit (config.services.nextcloud) occ;

      wopi_url = "http://127.0.0.1:${toString cfg.port}";
      public_wopi_url = "https://docs.${server.baseDomain}";
      wopi_allowlist = lib.concatStringsSep "," [
        "127.0.0.1"
        "::1"
      ];
    in
    {
      wantedBy = [ "multi-user.target" ];
      after = [
        "nextcloud-setup.service"
        "coolwsd.service"
      ];
      requires = [ "coolwsd.service" ];
      script = ''
        ${occ}/bin/nextcloud-occ config:app:set richdocuments wopi_url --value ${lib.escapeShellArg wopi_url}
        ${occ}/bin/nextcloud-occ config:app:set richdocuments public_wopi_url --value ${lib.escapeShellArg public_wopi_url}
        ${occ}/bin/nextcloud-occ config:app:set richdocuments wopi_allowlist --value ${lib.escapeShellArg wopi_allowlist}
        ${occ}/bin/nextcloud-occ richdocuments:setup
      '';
      serviceConfig = {
        Type = "oneshot";
      };
    };

  systemd.services.coolwsd = {
    serviceConfig = {
      ProtectSystem = "strict";
      ProtectHome = true;
      PrivateTmp = true;
      CapabilityBoundingSet = [
        "CAP_FOWNER"
        "CAP_CHOWN"
        "CAP_SYS_CHROOT"
        "CAP_SYS_ADMIN"
        "CAP_MKNOD"
      ];
    };
  };
}
