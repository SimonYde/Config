{
  pkgs,
  lib,
  config,
  ...
}:
let
  inherit (lib) getExe mkForce;
  colors = config.lib.stylix.colors.withHashtag;
  font = config.stylix.fonts.sansSerif;
in
{
  programs.rofi = {
    package = pkgs.rofi-wayland;
    font = mkForce "${font.name} 14";
    terminal = getExe pkgs.${config.syde.gui.terminal};
    theme = mkForce "custom_base16";
    extraConfig = {
      modi = "run,drun";
      icon-theme = "Oranchelo";
      show-icons = true;
      drun-display-format = "{icon} {name}";
      disable-history = false;
      hide-scrollbar = true;
      sidebar-mode = false;
      display-drun = "  Apps ";
      display-run = "  Run ";
    };
    plugins = with pkgs; [
      rofi-emoji-wayland
    ];
  };

  xdg.configFile."rofi/custom_base16.rasi" = {
    inherit (config.programs.rofi) enable;
    text =
      with colors;
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
        }
      ''
      + builtins.readFile ./rofi-theme.rasi;
  };
}
