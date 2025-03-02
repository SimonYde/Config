{ config, ... }:

let
  inherit (config.syde) user;
in
{
  imports = [ ./shared.nix ];

  home-manager.users.${user}.imports = [ ./home.nix ];

  # Leaving this here if I want to disable `nixos` targets later.
}
