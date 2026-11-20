{ ... }:

{
  imports = [
    ./acme.nix
    ./netbird-proxy.nix
    ./nginx.nix
    ./opencode.nix
    ./samba.nix
    ./syncthing.nix
    ./wireguard-netns.nix
  ];
}
