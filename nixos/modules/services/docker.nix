{ lib, config, ... }:
let
  cfg = config.virtualisation.docker;
in
{
  config = lib.mkIf cfg.enable {
    users.extraGroups.docker.members = [
      config.syde.user
    ];
  };
}
