{ pkgs, ... }:
{
  imports = [ ../standard.nix ];

  programs.nh.enable = true;

  syde = {
    ssh.enable = true;
    wsl.enable = true;
  };

  nixpkgs.config.allowUnfree = true;

  services = {
    ollama.enable = true;
    syncthing.enable = true;
    tailscale.enable = true;
    vscode-server.enable = false;
  };

  networking.hostName = "icarus";
}
