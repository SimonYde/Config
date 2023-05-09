{ pkgs, ... }:

{
	programs.brave = {
		extensions = [
			{ id = "gphhapmejobijbbhgpjhcjognlahblep"; } # GNOME Shell integration
			{ id = "eimadpbcbfnmbkopoojfekhnkhdbieeh"; } # Dark Reader
		];
	};
}
