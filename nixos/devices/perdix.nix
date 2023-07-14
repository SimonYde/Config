{ pkgs, config, lib, ...}:

{
  imports = [
    # ../modules/desktops/sway.nix
    ../modules/desktops/i3.nix
    ../modules/pc.nix
    ../modules/hardware/laptop.nix
    ../modules/hardware/graphics/nvidia.nix
    ../modules/hardware/graphics/amd.nix
  ];
  networking.hostName = "perdix";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  environment.systemPackages = with pkgs; [
    gparted
  ];
}
