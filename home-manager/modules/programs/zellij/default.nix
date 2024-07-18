{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.programs.zellij;
  zellij_path = "${config.xdg.configHome}/zellij";
in
{
  config = lib.mkIf cfg.enable {
    programs.zellij = {
      enableBashIntegration = false;
      enableZshIntegration = false;
      enableFishIntegration = false;
    };

    home.shellAliases = {
      zs = "zellij --session";
      zp = "zellij --session $(basename $PWD)";
      za = "zellij attach $(zellij list-sessions | ${pkgs.skim}/bin/sk --ansi | awk '{ print $1 }')";
    };
    xdg.configFile."zellij/config.kdl".text =
      with config.syde.theming.palette-hex;
      builtins.readFile ./keybinds.kdl
      +
        # kdl
        ''
          theme "base16-custom"
          themes {
            base16-custom {
              bg "${base02}"
              fg "${base05}"
              red "${base08}"
              green "${base0D}"
              blue "${base0D}"
              yellow "${base0A}"
              magenta "${base0E}"
              orange "${base09}"
              cyan "${base0C}"
              black "${base01}"
              white "${base05}"
            }
          }
          layout_dir "${zellij_path}/layouts"
          default_layout "custom_compact"
          default_shell "${pkgs.fish}/bin/fish"
          default_mode "locked"
          simplified_ui true
          pane_frames false
          mouse_mode true
        '';

    xdg.configFile."zellij/layouts/custom_compact.kdl".text = # kdl
      ''
        layout {
          pane size=1 borderless=true {
            plugin location="zellij:compact-bar"
          }
          pane
        }
      '';
  };
}
