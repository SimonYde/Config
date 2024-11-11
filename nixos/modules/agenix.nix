{
  inputs,
  pkgs,
  config,
  lib,
  ...
}:

let
  ageBin = lib.getExe pkgs.rage;
in
{
  config = {
    environment.systemPackages = [
      inputs.agenix.packages.${pkgs.system}.default
    ];

    age.identityPaths = [ "/home/${config.syde.user}/.ssh/id_ed25519" ];
    age.ageBin = ageBin;

    age.secrets = {
      wireguard.file = ../../secrets/wireguard.age;
      pc-password.file = ../../secrets/pc-password.age;
    };
  };

  imports = [ inputs.agenix.nixosModules.default ];
}
