{ ... }:
{
  imports = [
    # Display managers
    ./gdm.nix
    ./sddm.nix

    # Other
    ./ssh.nix
    ./syncthing.nix
    ./ollama.nix
    ./tailscale.nix
    ./vscode-server.nix
  ];
}
