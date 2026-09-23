{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
let
  iface = "wg-exit";
  table = 39;

  # Private fwmark, kept outside Tailscale's mark namespace (bits 8-15, used
  # for its 0x400 forward mark and 0x1bd00/0x80000 rules) so this setup does
  # not rely on Tailscale's marks or masquerade. Bits 16-23 survive Tailscale's
  # `mark & 0xffff04ff` rewrite.
  mark = "0x020000";
  mask = "0xff0000";

  tailnet4 = "100.64.0.0/10";
  tailnet6 = "fd7a:115c:a1e0::/48";

  # Destinations that must keep using the main routing table, i.e. traffic that
  # isn't leaving through the VPN (tailnet peers, the local LAN, link-local).
  exclude4 = [
    tailnet4
    "192.168.1.0/24"
  ];
  exclude6 = [
    tailnet6
    "fe80::/10"
  ];

  toSet = lib.concatStringsSep ", ";

  routingUnit =
    family:
    let
      ip = "ip -${toString family}";
    in
    {
      description = "Policy routing (IPv${toString family}) for Tailscale exit traffic via ${iface}";

      bindsTo = [ "wg-quick-${iface}.service" ];
      partOf = [ "wg-quick-${iface}.service" ];
      after = [ "wg-quick-${iface}.service" ];
      wantedBy = [ "multi-user.target" ];

      path = [ pkgs.iproute2 ];

      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
      };

      script = ''
        ${ip} route replace default dev ${iface} table ${toString table}
        ${ip} rule add fwmark ${mark}/${mask} lookup ${toString table} priority 1000 || true
      '';

      preStop = ''
        ${ip} rule del fwmark ${mark}/${mask} lookup ${toString table} priority 1000 || true
        ${ip} route flush table ${toString table}
      '';
    };
in
{
  # Full wg-quick config for the remote VPN. It must contain `Table = off` so
  # that the default route is not installed into the main table.
  age.secrets.wireguardExitNode.file = "${inputs.secrets}/wireguard/exitnode.age";

  services.tailscale.extraSetFlags = [ "--advertise-exit-node" ];

  networking = {
    wg-quick.interfaces.${iface}.configFile = config.age.secrets.wireguardExitNode.path;

    # The NixOS forward chain is `policy drop`; allow traffic arriving from the
    # tailnet to be forwarded (out through ${iface}).
    firewall.extraForwardRules = ''
      iifname "tailscale0" accept
    '';

    # Exit-node traffic is marked in the prerouting hook (visible to the
    # forwarding route lookup) and masqueraded on the way out of ${iface}. The
    # forward chain is a kill switch: a marked packet is dropped unless it
    # actually leaves through ${iface}, so a down tunnel fails closed instead
    # of leaking out the main table.
    nftables.tables."ts-exit" = {
      family = "inet";
      content = ''
        chain prerouting {
          type filter hook prerouting priority mangle; policy accept;

          iifname != "tailscale0" return

          ip  saddr ${tailnet4} ip  daddr != { ${toSet exclude4} } counter meta mark set meta mark & 0xff00ffff | ${mark}
          ip6 saddr ${tailnet6} ip6 daddr != { ${toSet exclude6} } counter meta mark set meta mark & 0xff00ffff | ${mark}
        }

        chain forward {
          type filter hook forward priority filter; policy accept;

          meta mark & ${mask} == ${mark} oifname != "${iface}" counter drop
        }

        chain postrouting {
          type nat hook postrouting priority srcnat; policy accept;

          oifname "${iface}" meta mark & ${mask} == ${mark} counter masquerade
        }
      '';
    };
  };

  # Policy routing is split per address family so a failure or missing IPv6
  # address cannot abort the IPv4 rules (both are `set -e` scripts).
  systemd.services = {
    wg-exit-routing4 = routingUnit 4;
    wg-exit-routing6 = routingUnit 6;
  };
}
