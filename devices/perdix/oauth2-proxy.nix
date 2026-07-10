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
      virtualHosts = { };
    };
  };
}
