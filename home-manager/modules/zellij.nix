{ ... }:

{
	programs.zellij = {
		enableBashIntegration = true;
		enableZshIntegration  = true;
		enableFishIntegration = true;

    settings = {
	    theme = "catppuccin-mocha";
	    themes.monokai-pro = {
	      fg      = "#69676c";
	      bg      = "#222222";
	      black   = "#191919";
	      red     = "#fc618d";
	      green   = "#7bd88f";
	      yellow  = "#fce566";
	      blue    = "#5ad4e6";
	      magenta = "#948ae3";
	      cyan    = "#5ad4e6";
	      white   = "#f7f1ff";
	      orange  = "#fd9353";
			};
			themes.catppuccin-mocha = {
				bg      = "#585b70"; # Surface2
		    fg      = "#cdd6f4";
		    red     = "#f38ba8";
		    green   = "#a6e3a1";
		    blue    = "#89b4fa";
		    yellow  = "#f9e2af";
		    magenta = "#f5c2e7"; # Pink
		    orange  = "#fab387"; # Peach
		    cyan    = "#89dceb"; # Sky
		    black   = "#181825"; # Mantle
		    white   = "#cdd6f4";
			};
			default_layout = "compact";
			default_shell = "fish";
			on_force_close = "quit";
			simplified_ui = false;
			pane_frames   = false;	
			copy_command = "xclip -selection clipboard";
		};
	};
}
