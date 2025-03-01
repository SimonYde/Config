{ ... }:
{
  imports = [
    ./docker.nix
    ./kanata.nix
    ./ollama.nix
    ./ratbagd.nix
    ./syncthing.nix
    ./tailscale.nix
    ./wireguard.nix
  ];
}
