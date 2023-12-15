{ pkgs, config, ... }:
{
  programs = {
    zathura.enable = true;
    nix-index.enable = true;
  };

  syde.ssh.enable = true;

  gtk.enable = true;
  qt.enable = true;

  home.packages = with pkgs; [
    libqalculate
    rclone
    keepassxc
    wl-clipboard
  ];

  imports = [
    ../standard.nix
  ];
}
