{ ... }:

{
  imports = [
    ./nginx.nix
    ./samba.nix
    ./syncthing.nix
    ./tailscale.nix
    ./wireguard-netns.nix
    ./oauth2-proxy.nix
  ];
}
