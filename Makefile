HOST = $(shell hostname)
HOME_MANAGER_FILES = $(shell find home-manager)
NIXOS_FILES = $(shell find nixos)

hm: $(HOME_MANAGER_FILES)
	home-manager --flake .#${HOST} --show-trace switch

os: $(NIXOS_FILES)
	sudo nixos-rebuild --flake .#${HOST} --show-trace switch
	git add $(NIXOS_FILES)
	@GENERATION=`nixos-rebuild --flake .#${HOST} list-generations | rg current`; \
	echo $$GENERATION; \
	git commit -m "NixOS ${HOST}: $$GENERATION"

boot: $(NIXOS_FILES)
	sudo nixos-rebuild --flake .#${HOST} --show-trace boot
	git add $(NIXOS_FILES)
	@GENERATION=`nixos-rebuild --flake .#${HOST} list-generations | rg current`; \
	echo $$GENERATION; \
	git commit -m "NixOS ${HOST}: $$GENERATION"

news:
	home-manager --flake .#${HOST} news

update:
	nix flake update --commit-lock-file
