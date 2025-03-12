default: update os

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
