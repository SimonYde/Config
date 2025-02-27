{
  inputs,
  pkgs,
  config,
  lib,
  ...
}:
{
  config = {
    age.identityPaths = [ "/home/${config.syde.user}/.ssh/id_ed25519" ];
    age.ageBin = lib.getExe pkgs.rage;

    age.secrets = {
      wireguard.file = ../../secrets/wireguard.age;
      pc-password.file = ../../secrets/pc-password.age;
      tailscale.file = ../../secrets/tailscale.age;
    };
  };

  imports = [ inputs.agenix.nixosModules.default ];
}
