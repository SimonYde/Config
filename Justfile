default: update os

stow:
	./stow.nu

news:
	nix run nixpkgs#home-manager -- news --flake .#stub

update:
	@nix flake update --commit-lock-file

os:
	@nh os switch . --ask

boot:
	@nh os boot .

light:
	@nh os switch -s light-theme

gaming:
	@nh os switch -s gaming
