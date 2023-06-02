{ ... }:

{
	programs.zellij = {
		enableBashIntegration = true;
		enableZshIntegration  = true;
		enableFishIntegration = true;

		settings = {
		theme = "custom";
		themes.custom = {
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

			simplified_ui = false;
			pane_frames   = false;	
		};
	};
}
