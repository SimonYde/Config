{
  pkgs,
  config,
  lib,
  ...
}:
{
  imports = [ ../standard.nix ];

  environment.systemPackages = with pkgs; [ ];

  # Personal configurations
  syde = {
    ssh.enable = true;
    laptop.enable = false;
    pc.enable = true;
    pc.keyboard.layout = "eu";
    gaming.enable = true;
    hardware = {
      nvidia = {
        enable = true;
        dedicated = true;
      };
      amd = {
        cpu.enable = true;
        gpu.enable = false;
      };
    };
  };

  programs = {
    nh.enable = true;
    kdeconnect.enable = true;
    sway.enable = false;
    hyprland.enable = true;
  };

  services = {
    blueman.enable = true;
    languagetool.enable = true;
    ollama.enable = true;
    tailscale.enable = true;
    syncthing.enable = true;
  };

  powerManagement.cpuFreqGovernor = "performance";

  networking.hostName = "icarus";
  networking.wireguard.enable = true;
  networking.wg-quick.interfaces = {
    proton-DK25 = {
      autostart = false;
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

  virtualisation.docker.enable = false;
  # # Filesystems

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/e37c4644-2a85-4cfd-adaf-87961ad57a72";
    fsType = "ext4";
  };

  boot.initrd.luks.devices."luks-1d0e845e-dd09-4c75-b92c-9ea67a00757b".device = "/dev/disk/by-uuid/1d0e845e-dd09-4c75-b92c-9ea67a00757b";

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/157E-B4A5";
    fsType = "vfat";
    options = [
      "fmask=0022"
      "dmask=0022"
    ];
  };
  swapDevices = [
    {
      device = "/var/lib/swapfile";
      size = 32 * 1024;
    }
  ];
}
