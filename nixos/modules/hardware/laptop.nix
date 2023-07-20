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
        disableWhileTyping = true;
        naturalScrolling = true;
        middleEmulation = true;
        tapping = true;
      };
    };
    programs.light.enable = true;
    hardware.bluetooth.enable = true;
    systemd.services."bluetooth".serviceConfig = {
      StateDirectory = "";
      ReadWritePaths="/persist/var/lib/bluetooth/";
    };
    systemd.tmpfiles.rules = [
      "d /var/lib/bluetooth 700 root root - -"
    ];
    systemd.targets."bluetooth".after = ["systemd-tmpfiles-setup.service"];
    fileSystems."/var/lib/bluetooth" = {
      device = "/persist/var/lib/bluetooth";
      options = [ "bind" "noauto" "x-systemd.automount" ];
      noCheck = true;
    };
  };
}
