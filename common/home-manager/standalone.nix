{
  lib,
  pkgs,
  inputs,
  ...
}:

{
  imports = [
    inputs.stylix.homeManagerModules.stylix
    ../base/theming/home.nix
    ../base/theming/shared.nix
    ../base/nix-settings.nix
    ./default.nix
    ./magic-gc.nix
  ];

  programs.home-manager.enable = true;
  nix.package = pkgs.lix;

  home.packages = [
    (lib.hiPrio pkgs.nushell-wrapped)
  ];
}
