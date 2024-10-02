{ pkgs, lib, ... }:
{
  programs = {
    zathura.enable = true;
  };

  syde.programs = {
    thunar = {
      defaultFilemanager = false;
      enable = false;
    };
  };

  syde = {
    email.enable = false;
    programming.enable = true;
    ssh.enable = true;
    terminal.enable = true;
    theming.enable = true;
  };

  xdg.mimeApps.enable = true;
  home.shellAliases = {
    ex = "explorer.exe";
    poweroff = "wsl.exe --shutdown NixOS";
  };

  syde.terminal.opacity = lib.mkForce 1.0;

  home.packages = with pkgs; [
    libqalculate
    rclone
    wl-clipboard
    xdg-utils
  ];

  imports = [ ../standard.nix ];
}
