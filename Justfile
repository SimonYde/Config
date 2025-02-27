news:
	home-manager --flake .#$(hostname) news

update:
	nix flake update --commit-lock-file

os:
	nh os switch

boot:
	nh os boot

home:
	nh home switch

full: (update) (home) (os)

gaming:
	nh os switch -s gaming
