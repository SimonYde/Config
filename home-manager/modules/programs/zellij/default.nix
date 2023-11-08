{ config, pkgs, ... }:
let
  flavour = config.themes.flavour;
  catppuccin = config.themes.catppuccin;
in
{
  programs.zellij = {
    package = pkgs.unstable.zellij;
    enableBashIntegration = false;
    enableZshIntegration = false;
    enableFishIntegration = false;

    # settings = {
    #   theme = "catppuccin";
    #   themes.catppuccin = with catppuccin.${flavour}; {
    #     bg = surface2;
    #     fg = text;
    #     red = red;
    #     green = green;
    #     blue = blue;
    #     yellow = yellow;
    #     magenta = mauve;
    #     orange = peach;
    #     cyan = teal;
    #     black = mantle;
    #     white = text;
    #   };
    #   default_layout = "compact";
    #   default_shell = "fish";
    #   simplified_ui = false;
    #   pane_frames = false;
    # };
  };
  home.file = let zellij_path = "${config.xdg.configHome}/zellij"; in {
    "${zellij_path}/config.kdl".text = with catppuccin.${flavour}; ''
      theme "catppuccin"
      themes {
        catppuccin {
          bg "${surface2}"
          fg "${text}"
          red "${red}"
          green "${lavender}"
          blue "${blue}"
          yellow "${yellow}"
          magenta "${mauve}"
          orange "${peach}"
          cyan "${teal}"
          black "${mantle}"
          white "${text}"
        }
      }
      layout_dir "${zellij_path}/layouts"
      default_layout "custom_compact"
      default_shell "${pkgs.fish}/bin/fish"
      default_mode "locked"
      simplified_ui true
      pane_frames false
      mouse_mode true
    '' + builtins.readFile ./keybinds.kdl;
    "${zellij_path}/layouts/custom_compact.kdl".text = ''
      layout {
        pane size=1 borderless=true {
          plugin location="zellij:compact-bar"
        }
        pane
      }
    '';
  };
}
