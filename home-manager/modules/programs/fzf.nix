{
  config,
  pkgs,
  lib,
  ...
}:
let
  fzp = pkgs.writeShellScriptBin "fzp" ''
    # 1. Search for text in files using Ripgrep
    # 2. Interactively narrow down the list using fzf
    # 3. Open the file in Vim
    ${pkgs.ripgrep}/bin/rg --color=always --line-number --no-heading --smart-case "''${*:-}" |
      ${pkgs.fzf}/bin/fzf --ansi \
          --color "hl:-1:underline,hl+:-1:underline:reverse" \
          --delimiter : \
          --preview '${pkgs.bat}/bin/bat --color=always {1} --highlight-line {2}' \
          --preview-window 'up,60%,border-bottom,+{2}+3/3,~3' \
          --bind 'enter:become($EDITOR {1} +{2})'
  '';
  fd = "${pkgs.fd}/bin/fd";
  cfg = config.programs.fzf;
in
{
  config = lib.mkIf cfg.enable {
    home.packages = [ fzp ];

    programs.fzf = {
      enableBashIntegration = true;
      enableFishIntegration = true;
      enableZshIntegration = true;
      changeDirWidgetCommand = "${fd} --type directory";
      fileWidgetCommand = "${fd} --type file";
      defaultCommand = "${fd} --type file";
      colors =
        with config.syde.theming.palette-hex;
        lib.mkForce {
          bg = "";
          "bg+" = "";
          fg = base05;
          "fg+" = base05;
        };
      defaultOptions = [ ];
    };
  };
}
