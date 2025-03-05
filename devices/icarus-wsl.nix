{
  pkgs,
  lib,
  username,
  ...
}:
{
  services = {
    syncthing.enable = true;
  };

  systemd.oomd.enable = lib.mkForce true;

  home-manager.users.${username} = {
    programs = {
      zathura.enable = true;

      nushell.shellAliases = {
        ex = "explorer.exe";
        poweroff = "wsl.exe --shutdown NixOS";
      };
    };

    home.packages = with pkgs; [
      libqalculate
      wl-clipboard
      xdg-utils
    ];
  };
}
