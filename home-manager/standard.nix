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

  options.syde = with lib; {
    unfreePredicates = mkOption {
      type = types.listOf types.str;
      default = [ ];
    };
  };

  imports = [
    ./home.nix
    ./terminal.nix
    ./modules/gtk.nix
    ./modules/qt.nix
    ./modules/themes.nix
    ./programming.nix
    ./modules/brave.nix
    ./modules/firefox.nix
    ./modules/sway.nix
    ./modules/i3.nix
    ./modules/services/redshift.nix
    ./modules/services/gammastep.nix
    ./modules/email.nix
  ];
}
