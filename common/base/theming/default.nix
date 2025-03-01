{ config, ... }:

let
  inherit (config.syde) user;
in
{
  imports = [
    ./stylix-shared.nix
    ./stylix-nixos.nix
  ];

  home-manager.users.${user}.imports = [ ./stylix-home.nix ];
}
