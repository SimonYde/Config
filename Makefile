HOST = $(shell hostname)
HOME_MANAGER_FILES = $(shell find home-manager)
NIXOS_FILES = $(shell find nixos)

home: $(HOME_MANAGER_FILES)
	home-manager --flake .#${HOST} --show-trace switch

os: $(NIXOS_FILES)
	sudo nixos-rebuild --flake .#${HOST} --show-trace switch

news: 
	home-manager --flake .#${HOST} news
