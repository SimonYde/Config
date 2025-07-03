{ config, lib, ... }:
{
  services = {
    jellyfin = {
      inherit (config.syde.server) user group;
      enable = true;
      # Jellyfin can't advertise a reverse proxy on DLNA. Ew.
      openFirewall = true;
    };

    nginx = {
      upstreams.jellyfin.servers."127.0.0.1:8096" = { };

      virtualHosts."jellyfin.${config.syde.server.baseDomain}".locations."/" = {
        proxyPass = "http://jellyfin";
        proxyWebsockets = true;
      };
    };
  };
}
