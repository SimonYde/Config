{ pkgs, config, ... }:

let
  theme = config.themes.flavour;
  font = config.syde.terminal.font;
in
{
  config = {
    programs.alacritty = {
      settings = {
        import = [
          (pkgs.fetchFromGitHub
            {
              owner = "Catppuccin";
              repo = "alacritty";
              rev = "3c808cb";
              sha256 = "sha256-w9XVtEe7TqzxxGUCDUR9BFkzLZjG8XrplXJ3lX6f+x0=";
            } + "/catppuccin-${theme}.yml")
        ];
        window = {
          opacity = 0.85;
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
          size = if config.wayland.windowManager.sway.enable then 11.5 else 8.5;
        };
        cursor = {
          style = {
            shape = "Beam";
            blinking = "Off";
          };
        };
        shell = {
          program = "${pkgs.fish}/bin/fish";
          args = [ "--login" ];
        };
        key_bindings = [
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
        # colors = {
        #   cursor = {
        #     text = "CellBackground";
        #     cursor = "CellForeground";
        #   };
        # };
      };
    };
  };
}
