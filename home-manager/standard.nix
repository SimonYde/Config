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
          i3status-rust    = pkgs.unstable.i3status-rust;
          xkeyboard-config = pkgs.unstable.xkeyboard-config;
          grawlix          = pkgs.callPackage ./packages/grawlix.nix { };
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
  };

  imports = [
    ./home.nix
    ./programming.nix
    ./terminal.nix
    ./modules
  ];
}
