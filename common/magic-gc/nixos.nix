{ config, pkgs, ... }:
let
  magic-gc = pkgs.callPackage ./package.nix {
    nix = config.nix.package;
  };
in
{
  environment.systemPackages = [ magic-gc ];

  systemd = {
    services.magic-gc = {
      unitConfig.Description = "Magic GC";
      serviceConfig.ExecStart = "${magic-gc}/bin/gc 1d";
    };
    timers.magic-gc = {
      wantedBy = [ "timers.target" ];

      timerConfig = {
        OnCalendar = "*-*-* 06:00:00";
        Persistent = true;
      };
    };
  };
}
