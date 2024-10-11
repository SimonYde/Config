{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib) mkEnableOption;
  cfg = config.syde.services.hyprland-autoname-workspaces;
in
{
  config = lib.mkIf cfg.enable {
    systemd.user.services.hyprland-autoname-workspaces = {
      Unit = {
        Description = "Random Background";
        PartOf = [ "hyprland-session.target" ];
        After = [ "hyprland-session.target" ];
      };
      Install = {
        WantedBy = [ "hyprland-session.target" ];
      };
      Service = {
        ExecStart = lib.getExe pkgs.hyprland-autoname-workspaces;
        Restart = "always";
        RestartSec = "1";
      };
    };
  };

  options.syde.services.hyprland-autoname-workspaces = {
    enable = mkEnableOption "enable hyprland-autoname-workspaces";
  };
}
