{ pkgs, ... }:

{
  qt = {
    enable = true;
    style.package = pkgs.adwaita-qt;
    style.name = "adwaita-dark";
  };
}
