{ pkgs, config, ... }:

let
  theme = config.themes.flavour;
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
          opacity = 1.0;
          dynamic_title = true;
        };
        font = {
          normal = {
            family = "JetBrains Mono Nerd Font Mono";
            style = "Regular";
          };
          bold = {
            family = "JetBrains Mono Nerd Font Mono";
            style = "Bold";
          };
          italic = {
            family = "JetBrains Mono Nerd Font Mono";
            style = "Italic";
          };
          bold_italic = {
            family = "JetBrains Mono Nerd Font Mono";
            style = "Bold Italic";
          };
          size = if config.wayland.windowManager.sway.enable then 11.5 else 7;
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
        ];
        colors = {
          cursor = {
            text = "CellBackground";
            cursor = "CellForeground";
          };
        };
      };
      /* package = pkgs.writeShellScriptBin "alacritty" ''
        #!/bin/sh
        ${pkgs.nixgl.nixGLIntel}/bin/nixGLIntel ${pkgs.alacritty}/bin/alacritty "$@"
        ''; */
    };
  };
}
