{
  lib,
  pkgs,
  config,
  ...
}:
let
  user = config.syde.user;
  cfg = config.programs.wireshark;
in

{
  config = lib.mkIf cfg.enable {
    users.users.${user}.extraGroups = [
      "wireshark"
    ];
    programs.wireshark.package = pkgs.wireshark;
  };
}
