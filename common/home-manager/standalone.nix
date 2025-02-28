{
  lib,
  pkgs,
  ...
}:

{
  # This file exists separately from the rest of the home-manager config, as
  # it needs to handle `nixpkgs` overlays in the case of standalone usage.
  programs.home-manager.enable = true;
  nix.package = pkgs.lix;

  home.packages = [
    (lib.hiPrio pkgs.nushell-wrapped)
  ];

  imports = [
    ../base/nix-settings.nix
    ../magic-gc/home.nix
    ./default.nix
  ];
}
