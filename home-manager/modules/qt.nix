{
  config,
  pkgs,
  lib,
  ...
}:
let
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
      pkgs.kdePackages.qtstyleplugin-kvantum
      pkgs.libsForQt5.qtstyleplugin-kvantum
    ];
    xdg.configFile = {
      "Kvantum/Catppuccin-Mocha-Lavender/Catppuccin-Mocha-Lavender/Catppuccin-Mocha-Lavender.kvconfig".source = "${kvantum}/share/Kvantum/Catppuccin-Mocha-Lavender/Catppuccin-Mocha-Lavender.kvconfig";
      "Kvantum/Catppuccin-Mocha-Lavender/Catppuccin-Mocha-Lavender/Catppuccin-Mocha-Lavender.svg".source = "${kvantum}/share/Kvantum/Catppuccin-Mocha-Lavender/Catppuccin-Mocha-Lavender.svg";
    };
  };
}
