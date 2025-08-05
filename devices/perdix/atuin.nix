{ config, ... }:
let
  inherit (config.syde) server;

  cfg = config.services.atuin;
in
{
  services.atuin = {
    enable = true;
    database.createLocally = true;
    openRegistration = false;
    port = 8888;
  };

  services.nginx = {
    upstreams.atuin.servers."127.0.0.1:${toString cfg.port}" = { };

    virtualHosts."atuin.ts.${server.baseDomain}".locations."/" = {
      proxyPass = "http://atuin";
      proxyWebsockets = true;
      extraConfig = ''
        add_header Alt-Svc 'h3=":$server_port"; ma=86400';
      '';
    };
  };
}
