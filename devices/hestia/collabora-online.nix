{ config, ... }:

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
            extraConfig = ''
              add_header Alt-Svc 'h3=":$server_port"; ma=86400';
            '';
          };

          "^~ /hosting/discovery" = {
            proxyPass = "http://collabora";
            proxyWebsockets = true;
            extraConfig = ''
              add_header Alt-Svc 'h3=":$server_port"; ma=86400';
            '';
          };

          "^~ /hosting/capabilities" = {
            proxyPass = "http://collabora";
            proxyWebsockets = true;
            extraConfig = ''
              add_header Alt-Svc 'h3=":$server_port"; ma=86400';
            '';
          };

          "~ ^/cool/(.*)/ws$" = {
            proxyPass = "http://collabora";
            proxyWebsockets = true;
            extraConfig = ''
              add_header Alt-Svc 'h3=":$server_port"; ma=86400';
            '';
          };

          "~ ^/(c|l)ool" = {
            proxyPass = "http://collabora";
            proxyWebsockets = true;
            extraConfig = ''
              add_header Alt-Svc 'h3=":$server_port"; ma=86400';
            '';
          };

          "^~ /cool/adminws" = {
            proxyPass = "http://collabora";
            proxyWebsockets = true;
            extraConfig = ''
              add_header Alt-Svc 'h3=":$server_port"; ma=86400';
            '';
          };
        };
      };
    };

    collabora-online = {
      enable = true;
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
}
