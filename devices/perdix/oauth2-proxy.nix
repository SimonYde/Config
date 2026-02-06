{ inputs, config, ... }:
let
  inherit (config.syde) server;
in
{
  age.secrets.oauth2ProxySecrets = {
    file = "${inputs.secrets}/perdixOauth2ProxySecrets.age";
    owner = "oauth2-proxy";
  };

  services.oauth2-proxy = {
    enable = true;
    oidcIssuerUrl = "https://auth.${server.baseDomain}/oauth2/openid/perdix";
    clientID = "perdix";

    nginx = {
      domain = "perdix-auth.ts.${server.baseDomain}";
      virtualHosts = {
        "prowlarr.ts.${server.baseDomain}".allowed_groups = [ "torrenters@auth.${server.baseDomain}" ];
        "sonarr.ts.${server.baseDomain}".allowed_groups = [ "torrenters@auth.${server.baseDomain}" ];
        "radarr.ts.${server.baseDomain}".allowed_groups = [ "torrenters@auth.${server.baseDomain}" ];
        "lidarr.ts.${server.baseDomain}".allowed_groups = [ "torrenters@auth.${server.baseDomain}" ];
        "bazarr.ts.${server.baseDomain}".allowed_groups = [ "torrenters@auth.${server.baseDomain}" ];
        "bitmagnet.ts.${server.baseDomain}".allowed_groups = [ "torrenters@auth.${server.baseDomain}" ];
        "jellyseerr.ts.${server.baseDomain}".allowed_groups = [ "torrenters@auth.${server.baseDomain}" ];
      };
    };
  };
}
