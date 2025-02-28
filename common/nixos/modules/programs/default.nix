{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkMerge mkIf;
  inherit (config.syde) user;
  cfg = config.programs;
in
{
  config = mkMerge [
    (mkIf cfg.virt-manager.enable {
      virtualisation.libvirtd.enable = true;
      users.groups.libvirtd.members = [ user ];

      virtualisation.spiceUSBRedirection.enable = true;
    })

    (mkIf cfg.wireshark.enable {
      programs.wireshark.package = pkgs.wireshark;
      users.extraGroups.wireshark.members = [ user ];
    })

    (mkIf cfg.nh.enable {
      programs.nh = {
        flake = "/home/${config.syde.user}/Config";
        clean = {
          enable = true;
          extraArgs = "--keep 3 --keep-since 3d";
        };
      };
    })
  ];
}
