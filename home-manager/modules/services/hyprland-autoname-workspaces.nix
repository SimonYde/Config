{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib) getExe mkEnableOption mkIf;
  cfg = config.syde.services.hyprland-autoname-workspaces;
in
{
  config = mkIf cfg.enable {
    systemd.user.services.hyprland-autoname-workspaces = {
      Unit = {
        Description = "hyprland-autoname-workspaces";
        PartOf = [ "hyprland-session.target" ];
        After = [
          "hyprland-session.target"
          (mkIf config.programs.waybar.enable "waybar.service")
        ];
      };
      Install = {
        WantedBy = [ "hyprland-session.target" ];
      };
      Service = {
        ExecStart = getExe pkgs.hyprland-autoname-workspaces;
        Restart = "always";
        RestartSec = "1";
      };
    };
  };

  options.syde.services.hyprland-autoname-workspaces = {
    enable = mkEnableOption "hyprland-autoname-workspaces service.";
  };
}
