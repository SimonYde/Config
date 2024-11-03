{ pkgs, ... }:
{
  imports = [ ../standard.nix ];

  syde = {
    ssh.enable = true;
    wsl.enable = true;
  };

  programs = {
    nh.enable = true;
  };

  security.polkit.enable = true;

  services = {
    dbus = {
      enable = true;
      packages = [ pkgs.gcr ];
    };
    syncthing.enable = true;
  };

  networking.hostName = "icarus-wsl";
}
