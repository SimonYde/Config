#!/usr/bin/env nu
#
# Test for DNS/routing leaks from a WireGuard network namespace.
# Run on the target NixOS host as root.
#
# Usage:
#   nu test-netns-leak.nu --namespace wg_extern --service qbittorrent

# Pretty print a section header.
def section [title: string] {
  print -e $"\n=== ($title) ==="
}

# Run a command inside a service's namespaces (all namespaces).
def nsenter-service [service: string, cmd: list<string>] {
  let pid = (^systemctl show --property=MainPID --value $"($service).service" | str trim)
  if ($pid == "0" or $pid == "") {
    print -e $"ERROR: service ($service) is not running or has no MainPID"
    return null
  }
  ^nsenter -a -t $pid ...$cmd
}

def main [
  --namespace (-n): string = "wg_extern"     # Network namespace name
  --service (-s): string = ""                # Service using useNetworkNamespace
  --endpoint (-e): string = "https://ipinfo.io/ip"  # IP echo endpoint
  --dns-host (-d): string = "api.ipify.org"       # DNS host that reveals resolver IP
] {
  section "Host public IP and DNS resolver"
  print "IP:    " (^curl -s -m 5 $endpoint)
  print "DNS:   " (^getent hosts $dns_host | str trim)

  section $"Namespace ($namespace) public IP and DNS resolver"
  print "IP:    " (^ip netns exec $namespace curl -s -m 5 $endpoint)
  print "DNS:   " (^ip netns exec $namespace getent hosts $dns_host | str trim)
  print "Routes:"
  ^ip netns exec $namespace ip route

  if $service != "" {
    section $"Service ($service) public IP and DNS resolver"
    print "IP:    " (nsenter-service $service [curl -s -m 5 $endpoint])
    print "DNS:   " (nsenter-service $service [getent hosts $dns_host] | str trim)
    print "Routes:"
    nsenter-service $service [ip route]
  }
}
