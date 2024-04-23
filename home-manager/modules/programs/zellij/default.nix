{
  config,
  pkgs,
  ...
}: {
  programs.zellij = {
    package = pkgs.zellij;
    enableBashIntegration = false;
    enableZshIntegration = false;
    enableFishIntegration = false;
  };
  home.file = let
    zellij_path = "${config.xdg.configHome}/zellij";
  in {
    "${zellij_path}/config.kdl".text = with config.colorScheme.palette;
      ''
        theme "base16-custom"
        themes {
          base16-custom {
            bg "#${base02}"
            fg "#${base05}"
            red "#${base08}"
            green "#${base07}"
            blue "#${base0D}"
            yellow "#${base0A}"
            magenta "#${base0E}"
            orange "#${base09}"
            cyan "#${base0C}"
            black "#${base01}"
            white "#${base05}"
          }
        }
        layout_dir "${zellij_path}/layouts"
        default_layout "custom_compact"
        default_shell "${pkgs.fish}/bin/fish"
        default_mode "locked"
        simplified_ui true
        pane_frames false
        mouse_mode true
      ''
      + builtins.readFile ./keybinds.kdl;

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
