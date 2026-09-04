{ ... }:

{
  imports = [
    ./nginx.nix
    ./oauth2-proxy.nix
    ./opencode.nix
    ./samba.nix
    ./syncthing.nix
    ./wireguard-netns.nix
  ];
}
