{
  inputs,
  config,
  lib,
  ...
}:
let
  inherit (config.syde) server;
  inherit (server) internalDomain;
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
      domain = "hestia-auth.${internalDomain}";
      virtualHosts = {
        "prowlarr.${internalDomain}".allowed_groups = [ "torrenters" ];
        "sonarr.${internalDomain}".allowed_groups = [ "torrenters" ];
        "radarr.${internalDomain}".allowed_groups = [ "torrenters" ];
        "lidarr.${internalDomain}".allowed_groups = [ "torrenters" ];
        "bazarr.${internalDomain}".allowed_groups = [ "torrenters" ];
        "bitmagnet.${internalDomain}".allowed_groups = [ "torrenters" ];
        "seerr.${internalDomain}".allowed_groups = [ "torrenters" ];
      };
    };
  };

  services.nginx.virtualHosts = {
    "hestia-auth.${internalDomain}" = {
      isInternal = true;
    };
  };
}
