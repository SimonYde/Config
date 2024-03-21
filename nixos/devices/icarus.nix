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
    vscode-server.enable = false;
    syncthing.enable = true;
  };

  networking.hostName = "icarus";
}
