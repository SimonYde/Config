{
  config,
  pkgs,
  lib,
  ...
}:

let
  inherit (lib) concatMapAttrsStringSep getExe;
  fd = getExe pkgs.fd;
  colors = concatMapAttrsStringSep "," (key: color: "${key}:${color}") config.programs.fzf.colors;
in
{
  programs.skim = {
    enableBashIntegration = true;
    enableFishIntegration = true;
    changeDirWidgetCommand = "${fd} -H --type directory";
    fileWidgetCommand = "${fd} -H --type file";
    defaultCommand = "${fd} -H --type file";
    defaultOptions = [
      "--multi"
      "--tabstop=4"
      "--color=${colors}"
    ];
  };
}
