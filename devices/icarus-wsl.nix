{
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (config.syde) user;
in
{
  programs = {
    nh.enable = true;
  };

  security.polkit.enable = true;

  services = {
    dbus.enable = true;
    syncthing.enable = true;
  };

  systemd.oomd.enable = lib.mkForce true;

  home-manager.users.${user} = {
    programs = {
      zathura.enable = true;
    };

    syde = {
      programming.enable = true;
      ssh.enable = true;
      terminal.enable = true;
    };

    xdg.mimeApps.enable = true;
    home.shellAliases = {
      ex = "explorer.exe";
      poweroff = "wsl.exe --shutdown NixOS";
    };
    programs.nushell.shellAliases = {
      ex = "explorer.exe";
      poweroff = "wsl.exe --shutdown NixOS";
    };

    home.packages = with pkgs; [
      libqalculate
      rclone
      wl-clipboard
      xdg-utils
    ];
  };
}
