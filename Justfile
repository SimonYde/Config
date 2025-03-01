news:
	home-manager --flake .#$(hostname) news

update:
	nix flake update --commit-lock-file
	nh os switch --ask

os:
	nh os switch

boot:
	nh os boot

home:
	nh home switch

gaming:
	nh os switch -s gaming
