{ username, ... }:

{
  home-manager.users.${username}.imports = [ ../home-manager/development.nix ];

  virtualisation.podman = {
    enable = true;
    defaultNetwork.settings.dns_enabled = true;
    dockerSocket.enable = true;
  };

  environment.variables = {
    # always use rootful podman
    CONTAINER_HOST = "unix:///run/podman/podman.sock";
  };

  programs.adb.enable = true;

  users.users.${username}.extraGroups = [
    "adbuser"
    "podman"
  ];
}
