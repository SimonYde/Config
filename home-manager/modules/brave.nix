{ inputs, pkgs, ... }:

{
	programs.brave = {
		package = pkgs.unstable.brave;
		extensions = [
			{ id = "gphhapmejobijbbhgpjhcjognlahblep"; } # GNOME Shell integration
			{ id = "eimadpbcbfnmbkopoojfekhnkhdbieeh"; } # Dark Reader
		];
	};
}
