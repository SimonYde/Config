{
  pkgs,
  inputs,
  config,
  ...
}:
{
  imports = [
    inputs.nixos-hardware.nixosModules.lenovo-ideapad-15arh05
    ../standard.nix
  ];
  config = {
    networking.hostName = "perdix";

    boot.kernelPackages = pkgs.linuxPackages_zen;

    # Personal configurations
    syde = {
      ssh.enable = true;
      laptop.enable = true;
      pc.enable = true;
      gaming.enable = true;
      gaming.specialisation = true;
      hardware = {
        nvidia.enable = true;
        amd.cpu.enable = true;
        amd.gpu.enable = true;
      };
    };

    programs = {
      nix-ld.enable = true;
      wireshark.enable = true;
      nh.enable = true;
      hyprland.enable = true;
    };

    services.desktopManager.cosmic.enable = false;
    services.displayManager.cosmic-greeter.enable = false;

    services = {
      tailscale = {
        enable = true;
        authKeyFile = config.age.secrets.tailscale.path;
      };
      syncthing.enable = true;
      kanata.enable = true;
    };

    networking.wireguard.enable = true;

    # Filesystems
    boot.initrd.luks.devices."luks-8c2b7981-b3e3-470e-aae7-2834b1352fa5".device =
      "/dev/disk/by-uuid/8c2b7981-b3e3-470e-aae7-2834b1352fa5";
    fileSystems."/boot" = {
      device = "/dev/disk/by-label/SYSTEM_DRV";
      fsType = "vfat";
    };

    fileSystems."/" = {
      device = "/dev/disk/by-label/nixos";
      fsType = "ext4";
    };

    swapDevices = [ { device = "/dev/disk/by-label/swap"; } ];

  };

}
