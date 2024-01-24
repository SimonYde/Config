{ pkgs, config, ... }:

let
  terminal = config.syde.terminal;
  colors = config.colorScheme.colors;
  font = terminal.font;
  fontSize = terminal.fontSize;
in
{
  config = {
    programs.alacritty = {
      settings = {
        window = {
          opacity = terminal.opacity;
          dynamic_title = true;
        };
        font = {
          normal = {
            family = font;
            style = "Regular";
          };
          bold = {
            family = font;
            style = "Bold";
          };
          italic = {
            family = font;
            style = "Italic";
          };
          bold_italic = {
            family = font;
            style = "Bold Italic";
          };
          size = fontSize;
        };
        cursor = {
          style = {
            shape = terminal.cursor;
            blinking = "Off";
          };
        };
        shell = {
          program = "${pkgs.fish}/bin/fish";
          args = [ "--login" ];
        };
        keyboard.bindings = [
          {
            key = "Return";
            mods = "Super|Shift";
            action = "SpawnNewInstance";
          }
          {
            key = "M";
            mode = "Vi|~Search";
            action = "Left";
          }
          {
            key = "E";
            mode = "Vi|~Search";
            action = "Up";
          }
          {
            key = "N";
            mode = "Vi|~Search";
            action = "Down";
          }
          {
            key = "I";
            mode = "Vi|~Search";
            action = "Right";
          }
          {
            key = "K";
            mode = "Vi|~Search";
            action = "SearchNext";
          }
          {
            key = "K";
            mods = "Shift";
            mode = "Vi|~Search";
            action = "SearchPrevious";
          }
          {
            key = "J";
            mode = "Vi|~Search";
            action = "WordRightEnd";
          }
          {
            key = "J";
            mods = "Shift";
            mode = "Vi|~Search";
            action = "WordLeftEnd";
          }
          {
            key = "L";
            mode = "Vi|~Search";
            action = "ToggleViMode";
          }
        ];
        colors = with colors; {
          primary = {
            background = "#${base00}";
            foreground = "#${base05}";
            # Bright and dim foreground colors
            dim_foreground = "#${base05}";
            bright_foreground = "#${base05}";
          };
          # Cursor colors
          cursor = {
            text = "#${base00}";
            cursor = "#${base06}";
            #     text = "CellBackground";
            #     cursor = "CellForeground";
          };
          vi_mode_cursor = {
            text = "#${base00}";
            cursor = "#${base07}";
          };
          # Search colors
          search = {
            matches = {
              foreground = "#${base00}";
              background = "#${base05}";
            };
            focused_match = {
              foreground = "#${base00}";
              background = "#${base0B}";
            };
          };

          # Keyboard regex hints
          hints = {
            start = {
              foreground = "#${base00}";
              background = "#${base0A}";
            };
            end = {
              foreground = "#${base00}";
              background = "#${base05}";
            };
          };
          # Selection colors
          selection = {
            text = "#${base00}";
            background = "#${base06}";
          };
          # Normal colors
          normal = {
            black = "#${base03}";
            red = "#${base08}";
            green = "#${base0B}";
            yellow = "#${base0A}";
            blue = "#${base0D}";
            magenta = "#${base0E}";
            cyan = "#${base0C}";
            white = "#${base05}";
          };
          # Bright colors
          bright = {
            black = "#${base04}";
            red = "#${base08}";
            green = "#${base0B}";
            yellow = "#${base0A}";
            blue = "#${base0D}";
            magenta = "#${base0E}";
            cyan = "#${base0C}";
            white = "#${base05}";
          };

          # Dim colors
          dim = {
            black = "#${base03}";
            red = "#${base08}";
            green = "#${base0B}";
            yellow = "#${base0A}";
            blue = "#${base0D}";
            magenta = "#${base0E}";
            cyan = "#${base0C}";
            white = "#${base05}";
          };

          indexed_colors = [
            { index = 16; color = "#FAB387"; }
            { index = 17; color = "#${base06}"; }
          ];
        };
      };
    };
  };
}
