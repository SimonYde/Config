{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf mkPackageOption;

  cfg = config.programs.walker;
in
{
  options.programs.walker = {
    enable = mkEnableOption "Walker. Multi-Purpose Launcher with a lot of features. Highly Customizable and fast.";
    package = mkPackageOption pkgs "walker" { };
    systemd.enable = mkEnableOption "autostart walker as a systemd service" // {
      default = true;
    };
  };

  config = mkIf cfg.enable {
    home.packages = [ cfg.package ];

    systemd.user.services = {
      walker = {
        Unit = {
          Description = "Autostart walker runner";
          After = [ config.wayland.systemd.target ];
          Requires = [ config.wayland.systemd.target ];
        };

        Service = {
          ExecStart = "${cfg.package}/bin/walker --gapplication-service";
          Restart = "always";
          RestartSec = 1;
        };

        Install.WantedBy = [ config.wayland.systemd.target ];
      };
    };
  };
}
