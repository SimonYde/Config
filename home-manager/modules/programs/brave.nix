{ pkgs, ... }:

{
	programs.brave = {
		package = pkgs.unstable.brave;
		extensions = [
      { id = "bkkmolkhemgaeaeggcmfbghljjjoofoh"; } # Catppuccin Mocha theme
      { id = "fhcgjolkccmbidfldomjliifgaodjagh"; } # Cookie AutoDelete
      { id = "jjhefcfhmnkfeepcpnilbbkaadhngkbi"; } # Readwise Highlighter
      { id = "dbepggeogbaibhgnhhndojpepiihcmeb"; } # Vimium
      { id = "clngdbkpkpeebahjckkjfobafhncgmne"; } # Stylus
      { id = "fjcldmjmjhkklehbacihaiopjklihlgg"; } # News Feed Eradicator
			{ id = "eimadpbcbfnmbkopoojfekhnkhdbieeh"; } # Dark Reader
			{ id = "oocalimimngaihdkbihfgmpkcpnmlaoa"; } # Teleparty
			# { id = "gphhapmejobijbbhgpjhcjognlahblep"; } # GNOME Shell integration
		];
	};
}