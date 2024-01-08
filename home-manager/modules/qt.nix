{ config, pkgs, lib, ... }:

let cfg = config.qt; in
{
  config = lib.mkIf cfg.enable {
    qt = {
      platformTheme = "qtct";
      style.package = pkgs.lightly-qt;
      # style.name = "bb10dark";
    };

    xdg.configFile = {
      "qt5ct/colors/Catppuccin-Mocha.conf".text = builtins.readFile
      (pkgs.fetchFromGitHub {
        owner = "catppuccin";
        repo = "qt5ct";
        rev = "89ee948";
        hash = "sha256-t/uyK0X7qt6qxrScmkTU2TvcVJH97hSQuF0yyvSO/qQ=";
      } + "/themes/Catppuccin-Mocha.conf");
    };
  };
}
