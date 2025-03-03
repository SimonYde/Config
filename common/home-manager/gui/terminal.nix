_: {

  programs = {
    ghostty.settings = {
      gtk-titlebar = false;
      gtk-adwaita = true;
      gtk-single-instance = true;
      unfocused-split-opacity = 0.95;
      window-decoration = false;

      keybind = [
        "ctrl+alt+m=goto_split:left"
        "ctrl+alt+n=goto_split:down"
        "ctrl+alt+e=goto_split:up"
        "ctrl+alt+i=goto_split:right"
        "ctrl+alt+tab=toggle_tab_overview"
      ];
    };

    kitty.settings = {
      disable_ligatures = "never";
      cursor_shape = "beam";
      cursor_blink_interval = 0;
    };
  };
}
