{ inputs, ... }:

{
  config = {
    nixpkgs = {
      overlays = [
        inputs.nur.overlays.default
        # inputs.helix.overlays.default
        inputs.neovim-nightly.overlays.default
        # inputs.hyprland.overlays.default

        (final: prev: {
          stable = import inputs.stable {
            config = prev.config;
            system = prev.system;
          };
          grawlix = inputs.grawlix.packages.${prev.system}.default;
          pix2tex = inputs.pix2tex.packages.${prev.system}.default;
          audiobook-dl = inputs.audiobook-dl.packages.${prev.system}.default;

          zjstatus = inputs.zjstatus.packages.${prev.system}.default;
          pay-respects = inputs.pay-respects.packages.${prev.system}.default;
          ghostty = inputs.ghostty.packages.${prev.system}.default;

          kattis-cli = inputs.kattis-cli.packages.${prev.system}.kattis-cli;
          kattis-test = inputs.kattis-cli.packages.${prev.system}.kattis-test;

          # TODO: Because unstable is cringe
          hyprlock = final.stable.hyprlock;
          bottles = final.stable.bottles;
          rocmPackages = final.stable.rocmPackages;
          heroic = final.stable.heroic;

          python312 = prev.python312.override {
            packageOverrides = pyfinal: pyprev: {
              randcrack = inputs.randcrack.packages.${prev.system}.default;
            };
          };
          python311 = prev.python311.override {
            packageOverrides = pyfinal: pyprev: {
              randcrack = inputs.randcrack.packages.${prev.system}.default;
            };
          };

          vimPlugins = prev.vimPlugins // {
            tip-vim = prev.vimUtils.buildVimPlugin {
              version = "nightly";
              pname = "tip.vim";
              src = inputs.tip-vim;
            };
            mini-nvim = prev.vimUtils.buildVimPlugin {
              version = "nightly";
              pname = "mini-nvim";
              src = inputs.mini-nvim;
            };
          };
        })
      ];
    };
  };

}
