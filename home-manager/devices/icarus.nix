{ pkgs, ... }:
{
  programs = {
    zathura.enable = true;
  };

  syde.programs = {
    thunar.enable = true;
  };

  syde = {
    terminal.enable = true;
    programming.enable = true;
    theming.enable = true;
    ssh.enable = true;
    fonts.enable = true;
  };

  home.shellAliases = {
    ex = "explorer.exe";
    poweroff = "wsl.exe --shutdown NixOS";
  };

  home.packages = with pkgs; [
    libqalculate
    rclone
    keepassxc
    wl-clipboard
  ];

  imports = [ ../standard.nix ];
}
