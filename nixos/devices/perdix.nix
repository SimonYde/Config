{
  pkgs,
  inputs,
  config,
  lib,
  ...
}:
{
  imports = [
    inputs.nixos-hardware.nixosModules.lenovo-ideapad-15arh05
    ../standard.nix
  ];

  home-manager.users.${config.syde.user} = { pkgs, ... }: {
    imports = [
      ../../home-manager/devices/perdix.nix
    ];
  };

  # Personal configurations
  syde = {
    ssh.enable = true;
    laptop.enable = true;
    pc.enable = true;
    gaming.enable = true;
    hardware = {
      nvidia.enable = true;
      amdgpu.enable = true;
    };
  };

  programs.nix-ld.enable = true;
  programs.nix-ld.package = pkgs.nix-ld-rs;
  programs.nix-ld.libraries = with pkgs; [
    ncurses
    libz
    libstdcxx5
  ];

  programs = {
    nh.enable = true;
    kdeconnect.enable = true;
    sway.enable = false;
    hyprland.enable = true;
  };

  services = {
    ollama.enable = true;
    tailscale.enable = true;
    syncthing.enable = true;
  };


  powerManagement.cpuFreqGovernor = "ondemand";

  networking.hostName = "perdix";
  networking.wireguard.enable = true;
  networking.wg-quick.interfaces = {
    proton-DK25 = {
      autostart = true;
      address = [ "10.2.0.2/32" ];
      dns = [ "10.2.0.1" ];
      privateKeyFile = config.age.secrets.wireguard.path;
      peers = [
        {
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

  swapDevices = [ { device = "/dev/disk/by-label/swap"; } ];
}
