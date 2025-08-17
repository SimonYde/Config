default: os

stow:
	./stow.nu

news:
	nix run nixpkgs#home-manager -- news --flake .#stub

update:
	@nix flake update --commit-lock-file
	@nh os switch . --ask

os:
	@nh os switch . --ask

host HOST:
	@nh os switch --ask --hostname {{HOST}} --target-host {{HOST}}

boot:
	@nh os boot .

light:
	@nh os switch -s light-theme

gaming:
	@nh os switch -s gaming
