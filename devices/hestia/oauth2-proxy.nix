{ inputs, config, lib, ... }:
let
  inherit (config.syde) server;
in
{
  age.secrets.oauth2ProxySecrets = {
    file = "${inputs.secrets}/oauth2-proxy/secrets-hestia.age";
    owner = "oauth2-proxy";
  };

  services.oauth2-proxy = {
    enable = true;
    oidcIssuerUrl = "https://${server.authDomain}/oauth2/openid/hestia";
    clientID = "hestia";

    nginx = {
      domain = "hestia-auth.i.simonyde.com";
      virtualHosts = {
        "prowlarr.i.simonyde.com".allowed_groups = [ "torrenters" ];
        "sonarr.i.simonyde.com".allowed_groups = [ "torrenters" ];
        "radarr.i.simonyde.com".allowed_groups = [ "torrenters" ];
        "lidarr.i.simonyde.com".allowed_groups = [ "torrenters" ];
        "bazarr.i.simonyde.com".allowed_groups = [ "torrenters" ];
        "bitmagnet.i.simonyde.com".allowed_groups = [ "torrenters" ];
        "seerr.i.simonyde.com".allowed_groups = [ "torrenters" ];
      };
    };
  };

    services.nginx.virtualHosts = {
      "hestia-auth.i.simonyde.com" = {
      isInternal = true;
      };
    };
}
