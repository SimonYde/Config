{
  lib,
  config,
  username,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf mkOption;

  cfg = config.syde.ctf;
in
{
  options.syde.ctf = {
    enable = mkEnableOption "CTF tools";
  };

  config = mkIf cfg.enable {
    programs.wireshark = {
      enable = true;
      package = pkgs.wireshark;
    };

    users.users.${username}.extraGroups = [
      "wireshark"
    ];

    home-manager.users.${username}.imports = [ ../home-manager/ctf.nix ];
  };
}
