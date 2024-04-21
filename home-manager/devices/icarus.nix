{ pkgs, config, ... }:
{
  programs = {
    zathura.enable = true;
  };

  syde.programs.thunar.enable = true;
  syde.ssh.enable = true;

  gtk.enable = true;
  qt.enable = true;

  home.shellAliases = {
    ex = "explorer.exe";
  };

  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [
    libqalculate
    rclone
    keepassxc
    wl-clipboard

    # Fonts
    source-sans-pro
    roboto
    font-awesome
  ];

  imports = [
    ../standard.nix
  ];
}
