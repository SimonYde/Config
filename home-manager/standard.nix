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
        experimental-features = flakes nix-command
        warn-dirty = false
      '';
    };

    xdg.enable = true;
    home.preferXdgDirectories = true;
  };

  imports = [
    ./home.nix
    ./programming.nix
    ./terminal.nix
    ./gui.nix
    ./modules
  ];
}
