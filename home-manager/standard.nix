{ pkgs, inputs, lib, config, ... }:

{
  config = {
    nixpkgs = {
      overlays = [
        inputs.nur.overlay
        inputs.helix.overlays.default
        inputs.neovim-nightly.overlays.default
        (self: super: {
          unstable = import inputs.unstable {
            config = pkgs.config;
            system = pkgs.system;
          };
          grawlix     = pkgs.callPackage ./packages/grawlix.nix { };
          pix2tex     = pkgs.callPackage ./packages/pix2tex { };
          kattis-cli  = pkgs.callPackage ./packages/kattis-cli.nix { };
          kattis-test = pkgs.callPackage ./packages/kattis-test.nix { };
        })
      ];
      config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) config.syde.unfreePredicates;
    };

    nix = {
      package = pkgs.nix;
      extraOptions = "experimental-features = flakes nix-command";
    };
  };

  options.syde = {
    unfreePredicates = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
    };
    browser = lib.mkOption {
      type = lib.types.enum [ "firefox" "brave" ];
      default = "firefox";
    };
  };

  imports = [
    ./home.nix
    ./programming.nix
    ./terminal.nix
    ./modules
  ];
}
