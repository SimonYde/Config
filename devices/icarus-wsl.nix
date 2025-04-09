{ lib, username, ... }:
{
  services = {
    syncthing.enable = true;
  };

  systemd.oomd.enable = lib.mkForce true;

  home-manager.users.${username} = {

    programs.zathura.enable = true;

    home.shellAliases = {
      ex = "explorer.exe";
      poweroff = "wsl.exe --shutdown NixOS";
    };
  };
}
