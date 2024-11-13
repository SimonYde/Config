{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib) mkEnableOption;
  cfg = config.syde.services.hyprsunset;
in
{
  config = lib.mkIf cfg.enable {
    systemd.user.services.hyprsunset = {
      Unit = {
        Description = "Hyprsunset - nighttime";
      };
      Service = {
        Type = "oneshot";
        ExecStart = "${lib.getExe pkgs.hyprsunset} -t 1800";
      };
    };

    systemd.user.timers.hyprsunset = {
      Unit = {
        Description = "Hyprsunset - a blue-light filter";
        PartOf = [ "hyprland-session.target" ];
        After = [ "hyprland-session.target" ];
      };
      Timer = {
        OnCalendar = "*-*-* 20:00:00";
        Unit = "hyprsunset.service";
        Persistent = true;
      };
      Install = {
        WantedBy = [ "hyprland-session.target" ];
      };
    };
  };

  options.syde.services.hyprsunset = {
    enable = mkEnableOption "enable hyprland-autoname-workspaces";
  };
}
