{
  inputs,
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib) removePrefix;
in
{
  config = {
    lib.meta = {
      configPath = "${config.home.homeDirectory}/Config";
      mkMutableSymlink =
        path:
        config.lib.file.mkOutOfStoreSymlink (
          config.lib.meta.configPath + removePrefix (toString inputs.self) (toString path)
        );
    };

    nix = {
      package = lib.mkDefault pkgs.nix;
      extraOptions = ''
        experimental-features = flakes nix-command pipe-operators
        warn-dirty = false
      '';
    };

    home = {
      username = "syde";
      homeDirectory = "/home/syde";
      stateVersion = "24.11";
      preferXdgDirectories = true;
    };

    xdg.enable = true;
    programs.home-manager.enable = true;
  };

  imports = [
    ./terminal.nix
    ./gui.nix
    ./modules
  ];
}
