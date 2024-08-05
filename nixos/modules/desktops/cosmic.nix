{ inputs, ... }:

{
  imports = [
    inputs.nixos-cosmic.nixosModules.default
  ];

  config = {

  };
}
