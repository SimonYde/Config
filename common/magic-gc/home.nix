{ config, pkgs, ... }:
let
  magic-gc = pkgs.callPackage ./package.nix {
    nix = config.nix.package;
  };
in
{
  home.packages = [ magic-gc ];

  systemd.user = {
    services.magic-gc = {
      Unit.Description = "Magic GC";
      Service.ExecStart = "${magic-gc}/bin/gc 1d";
    };
    timers.magic-gc = {
      Install.WantedBy = [ "timers.target" ];
      Timer = {
        OnCalendar = "*-*-* 06:00:00";
        Persistent = true;
      };
    };
  };
}
