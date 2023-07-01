{...}:

{
  imports = [
    ../modules/desktops/sway.nix
    ../modules/pc.nix
    ../modules/hardware/graphics/nvidia.nix
    ../modules/hardware/graphics/amd.nix
  ];
  networking.hostName = "perdix";
}
