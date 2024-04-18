{ config, pkgs, lib, ... }:

let
  catppuccin = (pkgs.fetchFromGitHub {
    owner = "catppuccin";
    repo = "qt5ct";
    rev = "89ee948";
    hash = "sha256-t/uyK0X7qt6qxrScmkTU2TvcVJH97hSQuF0yyvSO/qQ=";
  });
  kvantum = (pkgs.catppuccin-kvantum.override { accent = "Lavender"; variant = "Mocha"; });
  cfg = config.qt;
in
{
  config = lib.mkIf cfg.enable {
    qt = {
      platformTheme = "qtct";
      # style.package = pkgs.lightly-qt;
      style.package = kvantum;
      style.name = "kvantum";
    };

    home.packages = [
      # pkgs.kdePackages.breeze
      pkgs.kdePackages.qtstyleplugin-kvantum
      pkgs.libsForQt5.qtstyleplugin-kvantum
    ];
    xdg.configFile = {
      "Kvantum/Catppuccin-Mocha-Lavender/Catppuccin-Mocha-Lavender/Catppuccin-Mocha-Lavender.kvconfig".source = "${kvantum}/share/Kvantum/Catppuccin-Mocha-Lavender/Catppuccin-Mocha-Lavender.kvconfig";
      "Kvantum/Catppuccin-Mocha-Lavender/Catppuccin-Mocha-Lavender/Catppuccin-Mocha-Lavender.svg".source = "${kvantum}/share/Kvantum/Catppuccin-Mocha-Lavender/Catppuccin-Mocha-Lavender.svg";
    };

    xdg.configFile = {
      # "qt5ct/colors/Catppuccin-Mocha.conf".source = (catppuccin + "/themes/Catppuccin-Mocha.conf");
      # "qt5ct/colors/Catppuccin-Latte.conf".source = (catppuccin + "/themes/Catppuccin-Latte.conf");
      # "qt6ct/colors/Catppuccin-Mocha.conf".source = (catppuccin + "/themes/Catppuccin-Mocha.conf");
      # "qt6ct/colors/Catppuccin-Latte.conf".source = (catppuccin + "/themes/Catppuccin-Latte.conf");
    };
  };
}
