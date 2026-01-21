{ ... }:

{
  imports = [
    ./nginx.nix
    ./syncthing.nix
    ./tailscale.nix
    ./wireguard-netns.nix
  ];
}
