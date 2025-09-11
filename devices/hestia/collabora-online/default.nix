{ config, pkgs, ... }:

let
  inherit (config.syde) server;
in
{
  services = {
    nginx = {
      upstreams.collabora.servers."127.0.0.1:${toString config.services.collabora-online.port}" = { };

      virtualHosts."docs.${server.baseDomain}" = {

        locations = {
          "/" = {
            extraConfig = ''
              return 444;
            '';
          };

          "^~ /browser" = {
            proxyPass = "http://collabora";
            proxyWebsockets = true;
          };

          "^~ /hosting/discovery" = {
            proxyPass = "http://collabora";
            proxyWebsockets = true;
          };

          "^~ /hosting/capabilities" = {
            proxyPass = "http://collabora";
            proxyWebsockets = true;
          };

          "~ ^/cool/(.*)/ws$" = {
            proxyPass = "http://collabora";
            proxyWebsockets = true;
          };

          "~ ^/(c|l)ool" = {
            proxyPass = "http://collabora";
            proxyWebsockets = true;
          };

          "^~ /cool/adminws" = {
            proxyPass = "http://collabora";
            proxyWebsockets = true;
          };
        };
      };
    };

    collabora-online = {
      enable = true;

      package = pkgs.callPackage ./package.nix { };

      settings = {
        net.post_allow.host = [
          "cloud.${server.baseDomain}"
          "192\\.168\\.[0-9]{1,3}\\.[0-9]{1,3}"
        ];
        ssl = {
          enable = false;
          termination = true;
        };
      };
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
      ];
    };
  };
}
