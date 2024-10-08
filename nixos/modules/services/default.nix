{ ... }:
{
  imports = [
    # Display managers
    ./gdm.nix
    ./sddm.nix

    # Other
    ./docker.nix
    ./kanata.nix
    ./languagetool.nix
    ./ollama.nix
    ./ratbagd.nix
    ./ssh.nix
    ./syncthing.nix
    ./tailscale.nix
    ./vscode-server.nix
    ./wireguard.nix
  ];
}
