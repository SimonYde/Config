{ ... }:

{
  boot.initrd.luks.devices."luks-8c2b7981-b3e3-470e-aae7-2834b1352fa5".device = "/dev/disk/by-uuid/8c2b7981-b3e3-470e-aae7-2834b1352fa5";
  fileSystems."/" = {
    device = "/dev/disk/by-uuid/3224958c-f486-4eb8-a1bc-83dfb4a9932e";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/1EED-B458";
    fsType = "vfat";
  };

  swapDevices = [];
}
