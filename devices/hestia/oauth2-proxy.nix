{ inputs, config, lib, ... }:
let
  inherit (config.syde) server;
in
{
  age.secrets.oauth2ProxySecrets = {
    file = "${inputs.secrets}/hestiaOauth2ProxySecrets.age";
    owner = "oauth2-proxy";
  };

  services.oauth2-proxy = {
    enable = true;
    oidcIssuerUrl = "https://${server.authDomain}/oauth2/openid/hestia";
    clientID = "hestia";

    nginx = {
      domain = "hestia-auth.ts.simonyde.com";
      virtualHosts = {
        "prowlarr.ts.simonyde.com".allowed_groups = [ "torrenters" ];
        "sonarr.ts.simonyde.com".allowed_groups = [ "torrenters" ];
        "radarr.ts.simonyde.com".allowed_groups = [ "torrenters" ];
        "lidarr.ts.simonyde.com".allowed_groups = [ "torrenters" ];
        "bazarr.ts.simonyde.com".allowed_groups = [ "torrenters" ];
        "bitmagnet.ts.simonyde.com".allowed_groups = [ "torrenters" ];
        "seerr.ts.simonyde.com".allowed_groups = [ "torrenters" ];
      };
    };
  };

    services.nginx.virtualHosts = {
      "hestia-auth.ts.simonyde.com" = {
        acmeRoot = lib.mkForce null;
        enableACME = lib.mkForce false;
        useACMEHost = "ts.simonyde.com";
      };
    };
}
