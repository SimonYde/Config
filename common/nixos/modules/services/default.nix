{ ... }:
{
  imports = [
    ./docker.nix
    ./kanata.nix
    ./ollama.nix
    ./ratbagd.nix
    ./ssh.nix
    ./syncthing.nix
    ./tailscale.nix
    ./wireguard.nix
  ];
}
