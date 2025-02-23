{
  config,
  pkgs,
  lib,
  ...
}:

let
  fd = lib.getExe pkgs.fd;
  cfg = config.programs.skim;
in
{
  config = lib.mkIf cfg.enable {
    programs.skim = {
      enableBashIntegration = true;
      enableFishIntegration = true;
      enableZshIntegration = true;
      changeDirWidgetCommand = "${fd} -H --type directory";
      fileWidgetCommand = "${fd} -H --type file";
      defaultCommand = "${fd} -H --type file";
      defaultOptions = with config.syde.theming.palette-hex; [
        "--multi"
        "--tabstop=4"
        "--color=${
          builtins.concatStringsSep "," [
            "bg:\"\""
            "bg+:${base01}"
            "fg:${base05}"
            "fg+:${base06}"
            "header:${base0D}"
            "hl:${base0D}"
            "hl+:${base0D}"
            "info:${base0A}"
            "marker:${base0C}"
            "pointer:${base0C}"
            "prompt:${base0A}"
            "spinner:${base0C}"
          ]
        }"
      ];
    };
  };
}
