{
  lib,
  username,
  config,
  ...
}:
{
  home-manager.users.${username}.imports = [ ../home-manager/development.nix ];

  virtualisation = {
    podman = {
      enable = true;
      defaultNetwork.settings.dns_enabled = true;
      dockerCompat = true;
      dockerSocket.enable = true;
    };

    libvirtd.enable = lib.mkDefault config.programs.virt-manager.enable;
  };

  environment.variables = {
    # always use rootful podman
    CONTAINER_HOST = "unix:///run/podman/podman.sock";
  };

  programs.adb.enable = true;

  users.users.${username}.extraGroups = [
    "adbuser"
    "podman"
  ] ++ lib.optional config.virtualisation.libvirtd.enable "libvirtd";
}
