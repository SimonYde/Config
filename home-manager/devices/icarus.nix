{ pkgs, config, ... }:
{
  programs = {
    zathura.enable = true;
  };

  syde.ssh.enable = true;

  gtk.enable = true;
  qt.enable = true;

  home.packages = with pkgs; [
    libqalculate
    rclone
    keepassxc
    xfce.thunar
    wl-clipboard
  ];

  imports = [
    ../standard.nix
  ];
}
