{lib, config, ...}:
let
  user = config.syde.user;
  cfg = config.virtualisation.docker;
in
{
  config = lib.mkIf cfg.enable {
    users.users.${user}.extraGroups = [
      "docker"
    ];
  };
}
