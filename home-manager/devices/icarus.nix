{ pkgs, config, ... }:
{
  programs = {
    zathura.enable = true;
  };

  syde.programs.thunar.enable = true;
  syde.ssh.enable = true;
  syde.fonts.enable = true;

  gtk.enable = true;
  qt.enable = true;

  home.shellAliases = {
    ex = "explorer.exe";
  };


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
