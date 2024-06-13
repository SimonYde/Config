{
  inputs,
  pkgs,
  config,
  ...
}:

let
  ageBin = "${pkgs.rage}/bin/rage";
in
{
  config = {
    environment.systemPackages = [
      (inputs.agenix.packages.${pkgs.system}.default.override { inherit ageBin; })
    ];

    age.identityPaths = [ "/home/${config.syde.user}/.ssh/id_ed25519" ];
    age.ageBin = ageBin;

    age.secrets = {
      wireguard.file = ../../secrets/wireguard.age;
    };
  };

  imports = [ inputs.agenix.nixosModules.default ];
}
