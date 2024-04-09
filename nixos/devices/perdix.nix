{ pkgs, inputs, ... }:

{
  imports = [
    inputs.nixos-hardware.nixosModules.lenovo-ideapad-15arh05
    ../standard.nix
  ];

  environment.systemPackages = with pkgs; [
  ];

  # Personal configurations
  syde = {
    ssh.enable = true;
    laptop.enable = true;
    pc.enable = true;
    gaming.enable = false;
    hardware = {
      nvidia.enable = true;
      amdgpu.enable = true;
    };
  };

  programs = {
    sway.enable = false;
    hyprland.enable = true;
  };

  services = {
    tailscale.enable = true;
    syncthing.enable = true;
  };

  powerManagement.cpuFreqGovernor = "ondemand";

  networking.hostName = "perdix";
  networking.wireguard.enable = true;
  networking.wg-quick.interfaces = {
    wg0 = {
      autostart = true;
      address = [ "10.2.0.2/32" ];
      dns = [ "10.2.0.1" ];
      privateKeyFile = "/home/syde/.secrets/wireguard.key";
      peers = [
        {
          # proton DK#25
          publicKey = "sbjnjFtxUz4dxYfNL7WOVf1StMjjAhkiPLCPtVtlhRI=";
          allowedIPs = [ "0.0.0.0/0" ];
          endpoint = "193.29.107.162:51820";
        }
      ];
    };
  };

  virtualisation.docker.enable = true;

  # AMD cpu
  boot.kernelModules = [ "kvm-amd" ];

  # Filesystems
  boot.initrd.luks.devices."luks-8c2b7981-b3e3-470e-aae7-2834b1352fa5".device = "/dev/disk/by-uuid/8c2b7981-b3e3-470e-aae7-2834b1352fa5";
  fileSystems."/boot" = {
    device = "/dev/disk/by-label/SYSTEM_DRV";
    fsType = "vfat";
  };

  fileSystems."/" = {
    device = "/dev/disk/by-label/nixos";
    fsType = "ext4";
  };

  swapDevices = [{
    device = "/dev/disk/by-label/swap";
  }];
}
