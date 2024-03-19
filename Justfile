
host := `hostname`
NIXOS_FILES := `find nixos`

hm:
    home-manager --flake .#{{host}} switch --show-trace

os:
	sudo nixos-rebuild --flake .#{{host}} --show-trace switch
	git add $(NIXOS_FILES)
	GENERATION=`nixos-rebuild --flake .#{{host}} list-generations | rg current`; \
	echo $GENERATION; \
	git commit -m "NixOS {{host}}: $GENERATION"
