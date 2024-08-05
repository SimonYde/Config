{
  pkgs,
  lib,
  config,
  ...
}:
let
  inherit (lib) mkDefault mkForce mkIf;
  cfg = config.programs.rofi;
  palette = config.syde.theming.palette-hex;
  terminal = config.syde.terminal;
  font = config.syde.theming.fonts.sansSerif;
in
{
  config = mkIf cfg.enable {
    programs.rofi = {
      package = mkDefault pkgs.rofi-wayland;
      font = mkForce font.name;
      terminal = "${pkgs.${terminal.emulator}}/bin/${terminal.emulator}";
      theme = mkForce "custom_base16";
      extraConfig = {
        modi = "run,drun";
        icon-theme = "Oranchelo";
        show-icons = true;
        drun-display-format = "{icon} {name}";
        disable-history = false;
        hide-scrollbar = true;
        sidebar-mode = false;
        display-drun = "   Apps ";
        display-run = "   Run ";
      };
    };

    xdg.configFile."rofi/custom_base16.rasi".text =
      with palette;
      ''
        * {
            bg: ${base00}b2;
            bg-col: ${base00}00;
            bg-col-light: ${base00}00;
            border-col: ${base00}00;
            selected-col: ${base00}00;
            blue: ${base0D};
            fg-col: ${base05};
            fg-col2: ${base08};
            grey: ${base04};

            width: 600;
            font: "${font.name} 14";
        }
      ''
      + builtins.readFile ./rofi-theme.rasi;
  };
}
