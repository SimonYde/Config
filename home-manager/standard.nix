{ pkgs, inputs, lib, config, ... }:

{
  config = {
    nixpkgs = {
      overlays = [
        inputs.nur.overlay
        inputs.helix.overlays.default
        inputs.neovim-nightly.overlays.default
        (self: super: {
          stable = import inputs.stable {
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
      config.permittedInsecurePackages = [
        "electron-25.9.0"
      ];
    };

    nix = {
      package = pkgs.nix;
      extraOptions = ''
        experimental-features = flakes nix-command
        warn-dirty = false
      '';
    };
  };

  options.syde = {
    unfreePredicates = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
    };
    browser = lib.mkOption {
      type = lib.types.enum [ "firefox" "brave" "floorp" ];
      default = "floorp";
    };
  };

  imports = [
    ./home.nix
    ./programming.nix
    ./terminal.nix
    ./modules
  ];
}
