{ ... }:

{
  services = {
    jellyfin = {
      enable = true;
      user = "media";
      group = "media";
      # Jellyfin can't advertise a reverse proxy on DLNA. Ew.
      openFirewall = true;
    };

    nginx = {
      upstreams.jellyfin.servers."127.0.0.1:8096" = { };

      virtualHosts."jellyfin.simonyde.com".locations."/" = {
        proxyPass = "http://jellyfin";
        proxyWebsockets = true;
      };
    };
  };

}
