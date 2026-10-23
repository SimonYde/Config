{ config, ... }:
let

  inherit (config.syde.server) internalDomain;
in
{
  services = {
    unifi = {
      enable = true;
      openFirewall = true;
    };

    nginx = {
      upstreams.unifi.servers."127.0.0.1:8443" = { };

      virtualHosts."unifi.${internalDomain}" = {
        isInternal = true;

        locations."/" = {
          proxyPass = "https://unifi";
          extraConfig = ''
            proxy_ssl_verify off;
          '';
          proxyWebsockets = true;
        };
      };
    };
  };
}
