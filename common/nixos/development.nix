{ username, ... }:

{
  home-manager.users.${username}.imports = [ ../home-manager/development.nix ];
}
