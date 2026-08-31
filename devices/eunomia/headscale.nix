{
  lib,
  pkgs,
  config,
  inputs,
  ...
}:
let
  inherit (config.syde) server;
  inherit (lib)
    pipe
    attrsToList
    listToAttrs
    attrValues
    flatten
    ;

  unfoldAttrs =
    { name, value }:
    map (v: {
      inherit name;
      value = v;
    }) value;

  renderService =
    { name, value }:
    {
      name = "${value}.i.${server.baseDomain}";
      type = "A";
      value = name;
    };

  toRecords =
    x:
    pipe x [
      attrsToList
      (map unfoldAttrs)
      flatten
      (map renderService)
    ];

  toSplitConfig =
    x:
    pipe x [
      attrValues
      flatten
      (map (x: {
        name = "${x}.i.${server.baseDomain}";
        value = [ "100.100.100.100" ];
      }))
      listToAttrs
    ];

  services = {
    # hestia
    "100.64.0.1" = [
      "hestia-auth"
      "tranumparken"

      # Ahoy
      "bitmagnet"
      "bazarr"
      "lidarr"
      "prowlarr"
      "radarr"
      "seerr"
      "sonarr"
    ];

    # perdix
    "100.64.0.2" = [
      "atuin"
      "adguard"
      "languagetool"
      "opencode"
      "edgeos"
      "qui"

      # Monitoring
      "grafana"
      "loki"
      "mimir"
    ];
  };
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

          # workaround tailscale split DNS nonsense
          nameservers.split = toSplitConfig services;

          extra_records = toRecords services;
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
