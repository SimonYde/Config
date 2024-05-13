{
  pkgs,
  inputs,
  lib,
  config,
  ...
}:
let
  mini-nvim-nightly = pkgs.vimUtils.buildVimPlugin {
    version = "nightly";
    pname = "mini-nvim";
    src = inputs.mini-nvim-nightly;
  };
  neogit-nightly = pkgs.vimUtils.buildVimPlugin {
    version = "nightly";
    pname = "neogit";
    src = inputs.neogit-nightly;
  };
in
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
            config = pkgs.config;
            system = pkgs.system;
          };
          grawlix = pkgs.callPackage ./packages/grawlix.nix { };
          pix2tex = pkgs.callPackage ./packages/pix2tex { };
          kattis-cli = pkgs.callPackage ./packages/kattis-cli.nix { };
          kattis-test = pkgs.callPackage ./packages/kattis-test.nix { };
          vimPlugins = prev.vimPlugins // {
            mini-nvim = mini-nvim-nightly;
            neogit = neogit-nightly;
          };
        })
      ];
      config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) config.syde.unfreePredicates;
      config.permittedInsecurePackages = [ ];
    };

    nix = {
      package = pkgs.nix;
      extraOptions = ''
        experimental-features = flakes nix-command
        warn-dirty = false
      '';
    };

    xdg.enable = true;
  };

  options.syde = {
    unfreePredicates = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
    };
    browser = lib.mkOption {
      type = lib.types.enum [
        "firefox"
        "brave"
        "floorp"
      ];
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
