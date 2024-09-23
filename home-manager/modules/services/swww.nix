{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib) mkIf mkEnableOption;
  random-background = pkgs.callPackage ./random-background.nix {
    homeDirectory = config.home.homeDirectory;
    slug = config.colorScheme.slug;
  };
  cfg = config.syde.services.swww;
in
{
  config = lib.mkIf cfg.enable {
    systemd.user.services.swww-daemon = {
      Unit = {
        Description = "Swww daemon";
        PartOf = [ "graphical-session.target" ];
        After = [ "graphical-session.target" ];
      };
      Install = {
        WantedBy = [ "graphical-session.target" ];
      };
      Service = {
        ExecStart = "${pkgs.swww}/bin/swww-daemon";
        Restart = "always";
        RestartSec = "1";
      };
    };

    systemd.user.services.rand-bg = mkIf cfg.random-background {
      Unit = {
        Description = "Random Background";
      };
      Service = {
        Type = "oneshot";
        ExecStart = lib.getExe random-background;
      };
    };

    systemd.user.timers.rand-bg = mkIf cfg.random-background {
      Unit = {
        Description = "Random Background";
      };
      Timer = {
        OnStartupSec = "1sec";
        OnUnitActiveSec = "15min";
        Unit = "rand-bg.service";
      };
      Install = {
        WantedBy = [ "timers.target" ];
      };
    };

    home.packages = [
      pkgs.swww
      random-background
    ];
  };

  options.syde.services.swww = {
    enable = mkEnableOption "swww daemon";
    random-background = mkEnableOption "random background timer" // {
      default = true;
    };
  };
}
