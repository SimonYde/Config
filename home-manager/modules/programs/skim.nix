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
      changeDirWidgetCommand = "${fd} --type directory";
      fileWidgetCommand = "${fd} --type file";
      defaultCommand = "${fd} --type file";
      defaultOptions = with config.syde.theming.palette-hex; [
        "--multi"
        "--tabstop=4"
        "--color=${
          builtins.concatStringsSep "," [
            "dark"
            "border:${base04}"
            "current:${base05}"
            "current_bg:${base03}"
            "current_match:${base00}"
            "current_match_bg:${base06}"
            "cursor:${base08}"
            "fg:${base05}"
            "bg:none"
            "header:${base0C}"
            "info:${base0E}"
            "matched:${base02}"
            "matched_bg:${base0F}"
            "prompt:${base0D}"
            "selected:${base07}"
            "spinner:${base0B}"
          ]
        }"
      ];
    };
  };
}
