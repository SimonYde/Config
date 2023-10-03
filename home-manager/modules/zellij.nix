{ config, ... }:
let
  theme = config.themes.flavour;
  catppuccin = {
    mocha = {
      base      = "#1e1e2e";
      mantle    = "#181825";
      surface0  = "#313244";
      surface1  = "#45475a";
      surface2  = "#585b70";
      text      = "#cdd6f4";
      rosewater = "#f5e0dc";
      lavender  = "#b4befe";
      red       = "#f38ba8";
      pink      = "#f5c2e7";
      peach     = "#fab387";
      yellow    = "#f9e2af";
      green     = "#a6e3a1";
      teal      = "#94e2d5";
      blue      = "#89b4fa";
      sky       = "#89dceb";
      mauve     = "#cba6f7";
      flamingo  = "#f2cdcd";
    };
    latte = {
      base = "#eff1f5";
      mantle = "#e6e9ef";
      surface0 = "#ccd0da";
      surface1 = "#bcc0cc";
      surface2 = "#acb0be";
      text = "#4c4f69";
      rosewater = "#dc8a78";
      lavender = "#7287fd";
      red = "#d20f39";
      pink = "#ea76cb";
      peach = "#fe640b";
      yellow = "#df8e1d";
      green = "#40a02b";
      teal = "#179299";
      blue = "#1e66f5";
      sky = "#04a5e5";
      mauve = "#8839ef";
      flamingo = "#dd7878";
    };
  };
  in
{
	programs.zellij = {
		enableBashIntegration = false;
		enableZshIntegration  = false;
		enableFishIntegration = false;

    settings = {
	    theme = "catppuccin";
			themes.catppuccin = with catppuccin.${theme}; {
				bg      = surface2;
		    fg      = text;
		    red     = red;
		    green   = green;
		    blue    = blue;
		    yellow  = yellow;
		    magenta = pink;
		    orange  = peach;
		    cyan    = sky;
		    black   = mantle;
		    white   = text;
			};
			default_layout = "compact";
			default_shell = "fish";
			# on_force_close = "quit";
			simplified_ui = false;
			pane_frames   = false;	
			# copy_command = "xclip -selection clipboard";
		};
	};
}
