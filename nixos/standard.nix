{ lib, inputs, ... }:

let
  inherit (lib) mkOption types;
in
{
  config = {
    nixpkgs = {
      config.allowUnfree = true;
      overlays = [
        inputs.helix.overlays.default
        inputs.neovim-nightly.overlays.default
        inputs.nix-ld-rs.overlays.default
        inputs.nur.overlay
        inputs.rustaceanvim.overlays.default

        (final: prev: {
          stable = import inputs.stable {
            system = prev.system;
            config = prev.config;
          };
          grawlix = prev.callPackage ../home-manager/packages/grawlix.nix { };
          pix2tex = inputs.pix2tex.packages.${prev.system}.default;
          kattis-cli = prev.callPackage ../home-manager/packages/kattis-cli.nix { };
          kattis-test = prev.callPackage ../home-manager/packages/kattis-test.nix { };
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
    };
  };
  imports = [
    # home-manager.nixosModules.default
    ./modules/gaming.nix
    ./modules/agenix.nix
    ./modules/pc.nix
    ./modules/wsl.nix
    ./modules/desktops
    ./modules/programs
    ./modules/hardware
    ./modules/services
  ];

  options.syde = {
    shell = mkOption {
      type = types.str;
      default = "fish";
    };
    user = mkOption {
      type = types.str;
      default = "syde";
    };
  };
}
