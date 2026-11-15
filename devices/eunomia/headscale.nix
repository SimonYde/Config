{
  pkgs,
  config,
  inputs,
  ...
}:
let
  inherit (config.syde) server;
in
{
  age.secrets.headscaleClientSecret = {
    file = "${inputs.secrets}/headscaleClientSecret.age";
    owner = "headscale";
  };

  environment.systemPackages = [ pkgs.headscale ];

  services = {
    headscale = {
      enable = true;

      settings = {
        server_url = "https://ts.${server.baseDomain}/";
        listen_addr = "127.0.0.1:8085";
        metrics_listen_addr = "0.0.0.0:9092";

        trusted_proxies = [
          "127.0.0.1/32"
          "::1/128"
        ];

        prefixes = {
          v6 = "fd7a:115c:a1e0::/48";
          v4 = "100.64.0.0/10";
        };

        database = {
          type = "postgres";
          postgres = {
            host = "/run/postgresql";
            name = "headscale";
            user = "headscale";
          };
        };

        dns = {
          override_local_dns = false;
          base_domain = "nodes.ts.${server.baseDomain}";
        };

        node.expiry = 0; # do not auto expire nodes

        oidc = {
          only_start_if_oidc_is_available = true;
          issuer = "https://${server.authDomain}/oauth2/openid/headscale";
          client_id = "headscale";
          client_secret_path = config.age.secrets.headscaleClientSecret.path;
          scope = [
            "openid"
            "profile"
            "email"
          ];
          pkce.enabled = true;
        };

        derp.server = {
          enabled = true;
          region_code = "de";
          region_name = server.baseDomain;
          stun_listen_addr = "0.0.0.0:3479";
          ipv4 = server.addrs.v4;
          ipv6 = server.addrs.v6;
        };
      };
    };

    tailscale.enable = true;

    postgresql = {
      enable = true;
      ensureDatabases = [ "headscale" ];
      ensureUsers = [
        {
          name = "headscale";
          ensureDBOwnership = true;
        }
      ];
    };

    nginx = {
      upstreams.headscale.servers."127.0.0.1:8085" = { };

      virtualHosts."ts.${server.baseDomain}".locations."/" = {
        proxyPass = "http://headscale";
        proxyWebsockets = true;
      };
    };

    alloy.scrape.headscale.port = 9092;
  };

  systemd.services.headscale.after = [
    "kanidm.service"
    "nginx.service"
  ];

  networking.firewall.allowedUDPPorts = [ 3479 ];

}
