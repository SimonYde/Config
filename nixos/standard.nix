{
  lib,
  inputs,
  config,
  pkgs,
  ...
}:

let
  inherit (lib) mkOption types;
  user = config.syde.user;
in
{
  config = {
    nixpkgs = {
      config.allowUnfree = true;
      overlays = [
        inputs.nur.overlay
        inputs.helix.overlays.default
        inputs.neovim-nightly.overlays.default
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

        inputs.nix-ld-rs.overlays.default
      ];
    };

    environment.systemPackages = [
      (inputs.agenix.packages.${pkgs.system}.default.override { ageBin = "${pkgs.rage}/bin/rage"; })
    ];

    age.secrets.wireguard.file = ../secrets/wireguard.age;
    age.identityPaths = [ "/home/${user}/.ssh/id_ed25519" ];
  };
  imports = [
    inputs.agenix.nixosModules.default
    # home-manager.nixosModules.default
    ./modules/gaming.nix
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
