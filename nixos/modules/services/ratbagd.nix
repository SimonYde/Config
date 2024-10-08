{
  pkgs,
  config,
  lib,
  ...
}:

let
  cfg = config.services.ratbagd;
in
{
  config = lib.mkIf cfg.enable {
    services.ratbagd = {
      package = pkgs.libratbag.overrideAttrs (oldAttrs: rec {
        version = "v0.18";
        src = pkgs.fetchFromGitHub {
          owner = "libratbag";
          repo = "libratbag";
          rev = version;
          hash = "sha256-dAWKDF5hegvKhUZ4JW2J/P9uSs4xNrZLNinhAff6NSc=";
        };
      });
    };

    environment.systemPackages = [
      (pkgs.writeTextDir "share/libratbag/steelseries-aerox-3-wireless.device" ''
        [Device]
        Name=SteelSeries Aerox 3 Wireless
        DeviceMatch=usb:1038:1838;usb:1038:183a
        Driver=steelseries
        DeviceType=mouse

        [Driver/steelseries]
        DeviceVersion=1
        Buttons=6
        Leds=0
        DpiRange=100:18000@100
        MacroLength=0
      '')
      (pkgs.piper.overrideAttrs (oldAttrs: rec {
        version = "0.8";
        src = pkgs.fetchFromGitHub {
          owner = "libratbag";
          repo = "piper";
          rev = version;
          hash = "sha256-j58fL6jJAzeagy5/1FmygUhdBm+PAlIkw22Rl/fLff4=";
        };
        mesonFlags = [ "-Druntime-dependency-checks=false" ];
      }))
    ];
    services.dbus.packages = [ pkgs.libratbag ];
  };
}
