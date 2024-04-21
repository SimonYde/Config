{...}:

{
  imports = [
    # Display managers
    ./gdm.nix
    ./sddm.nix
    ./lightdm.nix


    # Other
    ./ssh.nix
    ./syncthing.nix
    ./ollama.nix
    ./tailscale.nix
    ./vscode-server.nix
  ];
}
