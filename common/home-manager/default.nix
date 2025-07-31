{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:
let
  inherit (lib) mkDefault removePrefix;
in
{
  imports = [
    inputs.agenix.homeManagerModules.default
    ./shell
  ];

  xdg.enable = true;

  age.package = pkgs.rage;

  # Save a bit of space on servers.
  manual.manpages.enable = false;
  programs.man.enable = mkDefault false;
  programs.wezterm.enable = true;

  lib.meta = {
    configPath = "/home/syde/Config"; # Should be the location of the config repo.

    mkMutableSymlink =
      path:
      config.lib.file.mkOutOfStoreSymlink (
        config.lib.meta.configPath + removePrefix (toString inputs.self) (toString path)
      );

    lazyNeovimPlugins = map (plugin: {
      inherit plugin;
      optional = true;
    });
  };

  home = {
    stateVersion = mkDefault "25.05";
    preferXdgDirectories = true;

    # FIXME: hack to reload dbus activated things
    activation.reloadDbus = lib.hm.dag.entryAfter [ "reloadSystemd" ] ''
      if [[ -v DBUS_SESSION_BUS_ADDRESS ]]; then
        run ${pkgs.systemd}/bin/busctl --user call org.freedesktop.DBus /org/freedesktop/DBus org.freedesktop.DBus ReloadConfig
      fi
    '';
  };
}
