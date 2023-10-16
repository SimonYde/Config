{ pkgs, ... }:

{
  qt = {
    enable = true;
    platformTheme = "gtk";
    style.package = pkgs.adwaita-qt;
    style.name = "adwaita-dark";
  };
}
