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
    ./tailscale.nix
    ./vscode-server.nix
  ];
}
