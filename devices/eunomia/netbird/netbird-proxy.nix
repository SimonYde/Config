{
  inputs,
  config,
  ...
}:
let
  inherit (config.syde) server;

  # Cluster apex for the private reverse-proxy services. Services will be
  # exposed as <name>.i.simonyde.com and resolved through NetBird's private
  # DNS for peers in the service's access groups.
  proxyDomain = server.internalDomain;

  certsDirectory = config.security.acme.certs."${proxyDomain}".directory;
in
{
  # One-time token creation (store the result as NB_PROXY_TOKEN in this
  # secret before deploying):
  #
  #   sudo NETBIRD_STORE_ENGINE_POSTGRES_DSN='postgres:///netbird?user=netbird&host=/run/postgresql' \
  #     netbird-mgmt admin token create --name netbird-private-proxy \
  #       --config /var/lib/netbird-mgmt/management.json
  age.secrets."netbird/proxy-environment".file = "${inputs.secrets}/netbird/proxy-environment.age";

  # Wildcard certificate requested through the existing Cloudflare DNS-01
  # setup. No public A/AAAA records or inbound ACME ports are needed.
  security.acme.certs."${proxyDomain}" = {
    extraDomainNames = [ "*.${proxyDomain}" ];
  };

  services = {
    alloy.scrape.netbird_proxy.port = 9193;

    netbird.proxy = {
      enable = true;

      domain = proxyDomain;
      address = "127.0.0.1:8843";
      managementAddress = "http://127.0.0.1:${toString config.services.netbird.server.management.port}";
      allowInsecure = true;
      private = true;
      requireSubdomain = true;

      environmentFile = config.age.secrets."netbird/proxy-environment".path;

      # Static wildcard certificate, renewed by the system ACME service.
      certificateDirectory = certsDirectory;
      certificateFile = "fullchain.pem";
      certificateKeyFile = "key.pem";
      supplementaryGroups = [ "acme" ];

      healthAddress = "127.0.0.1:9193";
      logLevel = "info";
    };
  };

  # Same-host management connection; avoids exposing the ProxyService gRPC
  # route through nginx.
  systemd.services.netbird-proxy = {
    after = [
      "netbird-management.service"
      "acme-${proxyDomain}.service"
    ];
  };
}
