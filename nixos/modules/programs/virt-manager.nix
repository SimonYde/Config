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
    # users.users.${user}.extraGroups = [ "libvirtd" ];

    virtualisation.spiceUSBRedirection.enable = true;
  };
}
