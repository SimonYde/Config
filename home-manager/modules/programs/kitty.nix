{
  config,
  ...
}:
let
  terminal = config.syde.terminal;
in
{
  programs.kitty = {
    settings = {
      cursor_shape = terminal.cursor;
      cursor_blink_interval = 0;
    };
  };
}
