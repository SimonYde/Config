{ inputs, pkgs, config, lib, ... }:

{
  imports = [
    # ../modules/desktops/sway.nix
    ../modules/desktops/i3.nix
    ../modules/pc.nix
    ../modules/hardware/laptop.nix
    ../modules/hardware/graphics/nvidia.nix
    ../modules/hardware/graphics/amd.nix
  ];
  
  nixpkgs.overlays = [ inputs.nixpkgs-wayland.overlay ];
  networking.hostName = "perdix";
  networking.wireguard.enable = true;
  networking.wg-quick.interfaces = {
    wg0 = {
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

  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  environment.systemPackages = with pkgs; [
    gparted
  ];
}
