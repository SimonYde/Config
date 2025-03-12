{ username, ... }:

{
  home-manager.users.${username}.imports = [ ../home-manager/development.nix ];

  programs.adb.enable = true;
  users.users.${username}.extraGroups = [
    "adbuser"
    "podman"
  ];

}
