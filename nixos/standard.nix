{lib, inputs, ...}:

{
  config = {
    nixpkgs.overlays = [
      inputs.nix-ld-rs.overlays.default
    ];

  };
  imports = [
    ./modules/gaming.nix
    ./modules/pc.nix
    ./modules/wsl.nix
    ./modules/desktops
    ./modules/programs
    ./modules/hardware
    ./modules/services
  ];

  options.syde = {
    shell = lib.mkOption {
      type = lib.types.str;
      default = "fish";
    };
  };

}
