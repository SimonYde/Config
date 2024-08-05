{
  config,
  ...
}:
let
  fontName = config.syde.theming.fonts.monospace.name;
  fontSize = config.syde.terminal.fontSize;
in
{
  programs.wezterm = {
  };
}
