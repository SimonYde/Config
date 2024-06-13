{
  inputs,
  pkgs,
  config,
  ...
}:

{
  config = {
    environment.systemPackages = [
      (inputs.agenix.packages.${pkgs.system}.default.override { ageBin = "${pkgs.rage}/bin/rage"; })
    ];

    age.secrets.wireguard.file = ../secrets/wireguard.age;
    age.identityPaths = [ "/home/${config.syde.user}/.ssh/id_ed25519" ];
  };

  imports = [ inputs.agenix.nixosModules.default ];
}
