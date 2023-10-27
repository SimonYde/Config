{ config, pkgs, ... }:

let
  sway = config.wayland.windowManager.sway.config;
in
{
  xsession.windowManager.i3.config =  {
    assigns  = sway.assigns;
    colors   = sway.colors;
    floating = sway.floating;
    fonts    = sway.fonts;
    gaps     = sway.gaps;
    menu     = sway.menu;
    modes    = sway.modes;
    modifier = sway.modifier;
    terminal = sway.terminal;
    window   = sway.window;
    bars = [
      (builtins.head sway.bars // { command = "${pkgs.i3}/bin/i3bar"; })
    ];

    defaultWorkspace = sway.defaultWorkspace;
    keybindings = sway.keybindings // {
      # i3 specific
      "${sway.modifier}+Escape" = "exec loginctl lock-session";
      "${sway.modifier}+Shift+Escape" = ''exec "i3-nagbar -t warning -m 'You pressed the exit shortcut. Do you really want to exit i3? This will end your X session.' -B 'Yes, exit i3' 'i3-msg exit'"'';
    };

    startup = [
      { command = "${pkgs.xss-lock}/bin/xss-lock --transfer-sleep-lock -- i3lock -e -c 181825 --nofork"; notification = false; }
      # { command = "dex --autostart --environment i3"; notification = false; }
      # { command = "nm-applet"; notification = false; }
      { command = "setxkbmap -layout us -variant colemak_dh"; }
      { command = "${pkgs.feh}/bin/feh --bg-fill ~/Config/assets/backgrounds/battlefield-catppuccin.png"; }
      { command = "obsidian"; }
    ];
  };
}
