{
  config,
  pkgs,
  lib,
  ...
}:
let
  fd = lib.getExe pkgs.fd;
  cfg = config.programs.fzf;
in
{
  config = lib.mkIf cfg.enable {
    programs.fzf = {
      enableBashIntegration = true;
      enableFishIntegration = true;
      changeDirWidgetCommand = "${fd} -H --type directory";
      fileWidgetCommand = "${fd} -H --type file";
      defaultCommand = "${fd} -H --type file";
      colors.bg = lib.mkForce "";
      defaultOptions = [ ];
    };
  };
}
