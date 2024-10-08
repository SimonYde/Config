{ pkgs, ... }:

pkgs.writeShellScriptBin "hyprland-gamemode" ''
  HYPRGAMEMODE=$(hyprctl getoption animations:enabled | sed -n '1p' | awk '{print $2}')

  # Hyprland performance
  if [ $HYPRGAMEMODE = 1 ]; then
      hyprctl --batch "\
          keyword animations:enabled 0;\
          keyword decoration:drop_shadow 0;\
          keyword decoration:blur:enabled 0;\
          keyword general:gaps_in 0;\
          keyword general:gaps_out 0;\
          keyword general:border_size 1;\
          keyword decoration:rounding 0"
      systemctl --user stop waybar.service
      systemctl --user stop hyprland-autoname-workspaces.service
      exit
  else
      hyprctl reload
      systemctl --user start waybar.service
      systemctl --user start hyprland-autoname-workspaces.service
      exit
  fi
''
