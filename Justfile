news:
	home-manager --flake .#$(hostname) news

update:
	nix flake update --commit-lock-file
