{ pkgs, ... }:
{
  programs = {
    zathura.enable = true;
  };

  syde = {
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

  home.packages = with pkgs; [
    libqalculate
    rclone
    wl-clipboard
    xdg-utils
  ];

  imports = [ ../standard.nix ];
}
