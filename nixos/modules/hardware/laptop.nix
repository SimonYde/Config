{ lib, ... }:

{
  config = {
    powerManagement = {
      cpuFreqGovernor = lib.mkDefault "powersave";
      powertop.enable = true;
    };
    services.xserver.libinput = {
      enable = true;
      touchpad = {
        naturalScrolling = true;
        middleEmulation = true;
        tapping = true;
      };
    };
    programs.light.enable = true;
    hardware.bluetooth.enable = true;
    systemd.services."bluetooth".serviceConfig = {
      StateDirectory = "";
    };
    fileSystems."/var/lib/bluetooth" = {
      device = "/persist/var/lib/bluetooth";
      options = [ "bind" "noauto" "x-systemd.automount" ];
      noCheck = true;
    };
  };
}
