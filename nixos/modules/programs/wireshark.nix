{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config.programs.wireshark;
in
{
  config = lib.mkIf cfg.enable {
    programs.wireshark.package = pkgs.wireshark;
    users.extraGroups.wireshark.members = [
      config.syde.user
    ];
  };
}
