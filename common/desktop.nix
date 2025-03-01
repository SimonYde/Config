{
  pkgs,
  lib,
  inputs,
  ...
}:
let
  inherit (lib)
    mkDefault
    ;
in
{

  imports = [
    ./base/theming
    ./nixos
    inputs.stylix.nixosModules.stylix
  ];

  config = {
    boot = {
      plymouth.enable = true;
      consoleLogLevel = 3;
      kernelParams = [ "quiet" ];

      initrd.availableKernelModules = [
        "nvme"
        "xhci_pci"
        "ahci"
        "usb_storage"
        "sd_mod"
      ];

      supportedFilesystems = [ "ntfs" ];

      loader = {
        systemd-boot = {
          enable = true;
          editor = false;
        };
        efi.canTouchEfiVariables = true;
      };
    };

    environment.systemPackages = with pkgs; [
      git
      helvum
    ];

    i18n.extraLocaleSettings = {
      LC_ADDRESS = "da_DK.UTF-8";
      LC_IDENTIFICATION = "da_DK.UTF-8";
      LC_MEASUREMENT = "da_DK.UTF-8";
      LC_MONETARY = "da_DK.UTF-8";
      LC_NAME = "da_DK.UTF-8";
      LC_NUMERIC = "da_DK.UTF-8";
      LC_PAPER = "da_DK.UTF-8";
      LC_TELEPHONE = "da_DK.UTF-8";
      LC_TIME = "da_DK.UTF-8";
    };

    console = {
      useXkbConfig = true;
      font = "Lat2-Terminus16";
    };

    networking = {
      firewall = {
        enable = true;
        allowedTCPPorts = [
          80 # HTTP
          443 # HTTPS
        ];
      };
      useDHCP = mkDefault true;
      networkmanager = {
        enable = true;
        wifi = {
          powersave = false;
          macAddress = "random";
        };
      };
    };

    services.udisks2.enable = true;

    hardware = {
      enableAllFirmware = true;
      enableRedistributableFirmware = true;
      enableAllHardware = true;
      steam-hardware.enable = true;
      uinput.enable = true;
    };

    services.pulseaudio.enable = false;
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      wireplumber.enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
    };
  };
}
