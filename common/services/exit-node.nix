{
  config,
  lib,
  pkgs,
  ...
}:
let
  iface = "wg-exit";
  table = 39;

  # NetBird's client interface (configured in common/applications/netbird-client.nix).
  nbIface = config.services.netbird.clients.default.interface;

  # Private fwmark. NetBird uses its own mark range for control/data plane
  # traffic (0x1bd00-0x1bdff, pinned below). Keep this in the top byte so it
  # neither collides with nor rewrites NetBird's marks; the daemon only ever
  # sets marks in its lower bytes.
  mark = "0x01000000";
  mask = "0xff000000";
  markClear = "0x00ffffff";

  # NetBird allocates IPv4 overlay addresses from 100.64.0.0/10 and IPv6
  # overlay addresses from a per-account ULA prefix (default fd00:4e42::/32).
  # fd00::/8 covers the default and other ULA prefixes.
  netbird4 = "100.64.0.0/10";
  netbird6 = "fd00::/8";

  # Destinations that must keep using the main routing table, i.e. traffic that
  # isn't leaving through the VPN (NetBird peers, the local LAN, link-local).
  exclude4 = [
    netbird4
    "192.168.0.0/16"
  ];
  exclude6 = [
    netbird6
    "fe80::/10"
    "ff00::/8"
  ];

  # Must be lower than NetBird's own rules (105 and 110) so marked exit traffic
  # is sent to the WireGuard table before NetBird sends it to its own table.
  routePriority = 100;

  toSet = lib.concatStringsSep ", ";

  routingUnit =
    family:
    let
      ip = "ip -${toString family}";
    in
    {
      description = "Policy routing (IPv${toString family}) for NetBird exit traffic via ${iface}";

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
        ${ip} rule add fwmark ${mark}/${mask} lookup ${toString table} priority ${toString routePriority} || true
      '';

      preStop = ''
        ${ip} rule del fwmark ${mark}/${mask} lookup ${toString table} priority ${toString routePriority} || true
        ${ip} route flush table ${toString table}
      '';
    };
in
{
  # `age.secrets.wireguardExitNode` must contain a full wg-quick config for the remote VPN. It must contain `Table = off` so
  # that the default route is not installed into the main table.

  # NetBird has no client-side "advertise exit node" flag. Configure this peer
  # as an exit node in the NetBird dashboard: add an exit node / 0.0.0.0/0 route
  # using this peer as the routing peer (the matching ::/0 route is created
  # automatically when IPv6 overlay is enabled), and leave masquerading on.
  services.netbird = {
    useRoutingFeatures = "both";

    # Pin NetBird's mark range so the top byte stays available for the exit
    # policy below.
    clients.default.environment.NB_FWMARK_BASE = "0x1bd00";
  };

  boot.kernel.sysctl = {
    "net.ipv4.conf.all.forwarding" = lib.mkOverride 50 true;
    "net.ipv6.conf.all.forwarding" = lib.mkOverride 50 true;
  };

  networking = {
    wg-quick.interfaces.${iface}.configFile = config.age.secrets.wireguardExitNode.path;

    # The NixOS forward chain is `policy drop`; allow traffic arriving from
    # NetBird to be forwarded (out through ${iface}). NetBird also inserts its
    # own accept rules, but keeping this explicit makes the dependency clear.
    firewall.extraForwardRules = ''
      iifname "${nbIface}" accept
    '';

    # Exit-node traffic is marked in the prerouting hook (visible to the
    # forwarding route lookup) and masqueraded on the way out of ${iface}.
    #
    # NetBird marks its own traffic in a mangle prerouting chain at priority
    # -150. This chain runs afterwards and only ORs in the top-byte mark, so
    # NetBird's marks are preserved. The forward hook is deliberately not used
    # for the kill switch: NetBird adds `iifname nb0 accept` rules to external
    # forward chains, which would bypass a drop rule there. The postrouting
    # hook cannot be bypassed that way and fails closed if the tunnel route
    # disappears for any reason.
    nftables.tables."nb-exit" = {
      family = "inet";
      content = ''
        chain prerouting {
          type filter hook prerouting priority -140; policy accept;

          iifname != "${nbIface}" return

          # Leave locally delivered traffic alone (including NetBird's redirected
          # traffic marks); only forwarded exit traffic gets our mark.
          fib daddr type != local ip  daddr != { ${toSet exclude4} } counter meta mark set meta mark & ${markClear} | ${mark}
          fib daddr type != local ip6 daddr != { ${toSet exclude6} } counter meta mark set meta mark & ${markClear} | ${mark}
        }

        chain killswitch {
          type filter hook postrouting priority mangle; policy accept;

          meta mark & ${mask} == ${mark} oifname != "${iface}" counter drop
        }

        chain postrouting-nat {
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
