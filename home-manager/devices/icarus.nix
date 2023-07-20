{ pkgs, ... }:
{
	programs.zellij = {
    settings = {
      mouse_mode = true;
		};
	};
  home.packages = with pkgs; [
		speedtest-cli
  ];
  imports = [
    ../home.nix
    ../standard.nix
  ];
}
