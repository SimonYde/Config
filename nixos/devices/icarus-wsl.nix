{ ... }:
{
  imports = [ ../standard.nix ];

  syde = {
    ssh.enable = true;
    wsl.enable = true;
  };

  programs = {
    nh.enable = true;
  };

  services = {
    languagetool.enable = true;
    ollama.enable = false;
    syncthing.enable = true;
    tailscale.enable = true;
    vscode-server.enable = false;
  };

  networking.hostName = "icarus-wsl";
}
