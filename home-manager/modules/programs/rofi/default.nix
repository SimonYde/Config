{
  pkgs,
  lib,
  config,
  ...
}:
let
  inherit (lib) mkDefault mkForce mkIf;
  cfg = config.programs.rofi;
  colors = config.colorScheme.palette;
  terminal = config.syde.terminal;
in
{
  config = mkIf cfg.enable {
    programs.rofi = {
      package = mkDefault pkgs.rofi-wayland;
      font = mkDefault terminal.font;
      terminal = terminal.emulator;
      theme = mkForce "custom_base16";
      extraConfig = {
        modi = "run,drun";
        icon-theme = "Oranchelo";
        show-icons = true;
        drun-display-format = "{icon} {name}";
        disable-history = false;
        hide-scrollbar = true;
        sidebar-mode = true;
        display-drun = "   Apps ";
        display-run = "   Run ";
      };
    };

    home.file = {
      "${config.xdg.configHome}/rofi/custom_base16.rasi".text =
        with colors;
        ''
          * {
              bg-col:  #${base00};
              bg-col-light: #${base00};
              border-col: #${base00};
              selected-col: #${base00};
              blue: #${base0D};
              fg-col: #${base05};
              fg-col2: #${base08};
              grey: #${base04};

              width: 600;
              font: "${terminal.font} 14";
          }
        ''
        + builtins.readFile ./rofi-theme.rasi;
    };
  };
}
