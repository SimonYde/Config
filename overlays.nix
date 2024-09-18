{ inputs, ... }:

{
  config = {
    nixpkgs = {
      overlays = [
        inputs.nur.overlay
        # inputs.helix.overlays.default
        inputs.nix-ld-rs.overlays.default
        inputs.neovim-nightly.overlays.default
        inputs.rustaceanvim.overlays.default

        (final: prev: {
          stable = import inputs.stable {
            config = prev.config;
            system = prev.system;
          };
          grawlix = prev.callPackage ./home-manager/packages/grawlix.nix { };
          pix2tex = inputs.pix2tex.packages.${prev.system}.default;

          delta = final.stable.delta;
          swaylock-effects = final.stable.swaylock-effects;

          kattis-cli = inputs.kattis-cli.packages.${prev.system}.kattis-cli;
          kattis-test = inputs.kattis-cli.packages.${prev.system}.kattis-test;
          vimPlugins = prev.vimPlugins // {
            mini-nvim = prev.vimUtils.buildVimPlugin {
              version = "nightly";
              pname = "mini-nvim";
              src = inputs.mini-nvim;
            };

            neogit = prev.vimUtils.buildVimPlugin {
              version = "nightly";
              pname = "neogit";
              src = inputs.neogit;
            };
          };
        })
      ];
    };
  };

}
