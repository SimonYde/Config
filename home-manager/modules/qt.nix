{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:
let
  catppuccin-qt5ct = inputs.catppuccin-qt5ct;
  kvantum = pkgs.catppuccin-kvantum.override {
    accent = "Lavender";
    variant = "Mocha";
  };
  cfg = config.qt;
in
{
  config = lib.mkIf cfg.enable {
    qt = {
      platformTheme = "qtct";
      style.package = kvantum;
      style.name = "kvantum";
    };

    home.packages = [
      # pkgs.kdePackages.breeze
      # pkgs.lightly-qt
      pkgs.kdePackages.qtstyleplugin-kvantum
      pkgs.libsForQt5.qtstyleplugin-kvantum
    ];
    xdg.configFile = {
      "Kvantum/Catppuccin-Mocha-Lavender/Catppuccin-Mocha-Lavender/Catppuccin-Mocha-Lavender.kvconfig".source = "${kvantum}/share/Kvantum/Catppuccin-Mocha-Lavender/Catppuccin-Mocha-Lavender.kvconfig";
      "Kvantum/Catppuccin-Mocha-Lavender/Catppuccin-Mocha-Lavender/Catppuccin-Mocha-Lavender.svg".source = "${kvantum}/share/Kvantum/Catppuccin-Mocha-Lavender/Catppuccin-Mocha-Lavender.svg";
    };

    xdg.configFile = {
      "qt5ct/colors/Catppuccin-Mocha.conf".source = catppuccin-qt5ct + "/themes/Catppuccin-Mocha.conf";
      "qt5ct/colors/Catppuccin-Latte.conf".source = catppuccin-qt5ct + "/themes/Catppuccin-Latte.conf";
      "qt6ct/colors/Catppuccin-Mocha.conf".source = catppuccin-qt5ct + "/themes/Catppuccin-Mocha.conf";
      "qt6ct/colors/Catppuccin-Latte.conf".source = catppuccin-qt5ct + "/themes/Catppuccin-Latte.conf";
    };
  };
}
