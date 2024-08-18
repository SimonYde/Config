{ ... }:

{
  # This file exists separately from the rest of the home-manager config, as
  # it needs to handle `nixpkgs` overlays in the case of standalone usage.
  config = {

    nixpkgs = {
      config = {
        allowUnfreePredicate = _: true;
        permittedInsecurePackages = [ ];
      };
    };
  };

  imports = [ ../overlays.nix ];
}
