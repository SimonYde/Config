#!/usr/bin/env nu
#
# Test WireGuard network namespace DNS configuration.
# Run on the target NixOS host as root (or via sudo).
#
# Usage:
#   nu test-netns-dns.nu --namespace wg_extern --service qbittorrent
#   nu test-netns-dns.nu --namespace wg_extern --service transmission

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

# Run a command inside the network namespace only.
def netns-exec [namespace: string, cmd: list<string>] {
  ^ip netns exec $namespace ...$cmd
}

def main [
  --namespace (-n): string = "wg_extern"      # Network namespace name
  --service (-s): string = ""                   # Service using useNetworkNamespace
  --dns-test (-d): list<string> = ["one.one.one.one" "google.com"]  # Hosts to resolve
] {
  section "Host /etc/resolv.conf"
  ^ls -la /etc/resolv.conf
  let host_target = (try { ^readlink -f /etc/resolv.conf } catch { "" })
  print $"canonical target: ($host_target)"

  section $"Netns file /etc/netns/($namespace)/resolv.conf"
  if ($"/etc/netns/($namespace)/resolv.conf" | path exists) {
    open $"/etc/netns/($namespace)/resolv.conf"
  } else {
    print -e "not found"
  }

  section $"Netns ($namespace) interfaces and routes"
  netns-exec $namespace [ip link]
  netns-exec $namespace [ip route]

  section $"Inside netns ($namespace) /etc/resolv.conf"
  netns-exec $namespace [cat /etc/resolv.conf]

  section $"Inside netns ($namespace) DNS resolution"
  for host in $dns_test {
    print $"host: ($host)"
    netns-exec $namespace [getent hosts $host]
  }

  if $service != "" {
    section $"Service ($service) status"
    ^systemctl status $"($service).service" --no-pager

    let pid = (^systemctl show --property=MainPID --value $"($service).service" | str trim)
    if ($pid == "0" or $pid == "") {
      print -e $"Service ($service) is not running, skipping service tests."
    } else {
      section $"Service ($service) process"
      print $"MainPID: ($pid)"
      ^ps -p $pid -o pid,comm,args

      section $"Service ($service) /etc/resolv.conf"
      nsenter-service $service [cat /etc/resolv.conf]

      section $"Service ($service) bind mounts"
      nsenter-service $service [findmnt /etc/resolv.conf]
      nsenter-service $service [findmnt /etc/nsswitch.conf]
      nsenter-service $service [findmnt /run/systemd/resolve/stub-resolv.conf]

      section $"Service ($service) network namespace"
      nsenter-service $service [ip link]
      nsenter-service $service [ip route]

      section $"Service ($service) DNS resolution"
      for host in $dns_test {
        print $"host: ($host)"
        nsenter-service $service [getent hosts $host]
      }
    }
  }
}
