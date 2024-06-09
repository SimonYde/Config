# This file exists separately from the rest of the home-manager config, as
# it needs to handle `nixpkgs` overlays in the case of standalone usage.

{
  lib,
  inputs,
  config,
  ...
}:

{
  config = {
    nixpkgs = {
      overlays = [
        inputs.nur.overlay
        inputs.helix.overlays.default
        inputs.neovim-nightly.overlays.default
        inputs.rustaceanvim.overlays.default
        (final: prev: {
          stable = import inputs.stable {
            config = prev.config;
            system = prev.system;
          };
          grawlix = prev.callPackage ./packages/grawlix.nix { };
          pix2tex = inputs.pix2tex.packages.${prev.system}.default;
          kattis-cli = prev.callPackage ./packages/kattis-cli.nix { };
          kattis-test = prev.callPackage ./packages/kattis-test.nix { };
          vimPlugins = prev.vimPlugins // {
            mini-nvim = prev.vimUtils.buildVimPlugin {
              version = "nightly";
              pname = "mini-nvim";
              src = inputs.mini-nvim;
            };

            neogit = prev.vimUtils.buildVimPlugin {
              version = "nightly";
              pname = "neogit";
              src = inputs.neogit-nightly;
            };
          };
        })
      ];
      config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) config.syde.unfreePredicates;
      config.permittedInsecurePackages = [ ];
    };
  };
}
