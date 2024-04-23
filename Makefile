HOST = $(shell hostname)
HOME_MANAGER_FILES = $(shell find home-manager)
NIXOS_FILES = $(shell find nixos)

hm: $(HOME_MANAGER_FILES)
	nh home switch

os: $(NIXOS_FILES)
	nh os switch
	git add nixos
	@GENERATION=`nixos-rebuild --flake .#${HOST} list-generations | rg current`; \
	echo $$GENERATION; \
	git commit -m "NixOS ${HOST}: $$GENERATION"

boot: $(NIXOS_FILES)
	nh os boot
	git add nixos
	@GENERATION=`nixos-rebuild --flake .#${HOST} list-generations | rg current`; \
	echo $$GENERATION; \
	git commit -m "NixOS ${HOST}: $$GENERATION"

news:
	home-manager --flake .#${HOST} news

update:
	nix flake update --commit-lock-file
