{
  config,
  lib,
  ...
}:

let
  cfg = config.programs.virt-manager;
in
{
  config = lib.mkIf cfg.enable {
    virtualisation.libvirtd.enable = true;
    users.groups.libvirtd.members = [ config.syde.user ];

    virtualisation.spiceUSBRedirection.enable = true;
  };
}
