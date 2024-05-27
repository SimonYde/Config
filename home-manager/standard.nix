{
  pkgs,
  inputs,
  lib,
  config,
  ...
}:
let
  inherit (lib) removePrefix getName types mkOption;
  inherit (builtins) elem;
  mini-nvim = pkgs.vimUtils.buildVimPlugin {
    version = "nightly";
    pname = "mini-nvim";
    src = inputs.mini-nvim;
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
          pix2tex = inputs.pix2tex.packages.${pkgs.system}.default;
          kattis-cli = pkgs.callPackage ./packages/kattis-cli.nix { };
          kattis-test = pkgs.callPackage ./packages/kattis-test.nix { };
          vimPlugins = prev.vimPlugins // {
            inherit mini-nvim;
            neogit = neogit-nightly;
          };
        })
      ];
      config.allowUnfreePredicate = pkg: elem (getName pkg) config.syde.unfreePredicates;
      config.permittedInsecurePackages = [ ];
    };

    lib.meta = {
      configPath = "${config.home.homeDirectory}/Config";
      mkMutableSymlink =
        path:
        config.lib.file.mkOutOfStoreSymlink (
          config.lib.meta.configPath + removePrefix (toString inputs.self) (toString path)
        );
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
    unfreePredicates = mkOption {
      type = types.listOf types.str;
      default = [ ];
    };
    browser = mkOption {
      type = types.enum [
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
