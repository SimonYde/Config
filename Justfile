default: update os

update:
	nix flake update --commit-lock-file

os:
	nh os switch --ask

boot:
	nh os boot

home:
	nh home switch

gaming:
	nh os switch -s gaming
