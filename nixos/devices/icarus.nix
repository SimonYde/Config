{ ... }:

{

  imports = [
    ../standard.nix
  ];


  syde = {
    ssh.enable = true;
    wsl.enable = true;
  };


  services = {
    syncthing.enable = true;
    tailscale.enable = true;
    vscode-server.enable = false;
  };

  networking.hostName = "icarus";
}
