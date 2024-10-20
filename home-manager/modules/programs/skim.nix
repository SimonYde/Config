{
  config,
  pkgs,
  lib,
  ...
}:

let
  skp = pkgs.writeShellScriptBin "skp" ''
    # 1. Search for text in files using Ripgrep
    # 2. Interactively narrow down the list using skim
    # 3. Open the file in Vim
    ${pkgs.skim}/bin/sk \
        --ansi \
        --delimiter : \
        --preview '${pkgs.bat}/bin/bat --color=always --highlight-line {2} {1}' \
        --preview-window +{2}-/2 \
        --bind 'enter:execute($EDITOR {1} +{2})' \
        --reverse \
        --interactive \
        --cmd \
        '${pkgs.ripgrep}/bin/rg --color=always --line-number --no-heading --smart-case "{}"'
  '';
  fd = "${pkgs.fd}/bin/fd";
  cfg = config.programs.skim;
in
{
  config = lib.mkIf cfg.enable {
    home.packages = [ skp ];
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
            "bg:${base00}"
            "bg+:${base01}"
            "fg:${base04}"
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
