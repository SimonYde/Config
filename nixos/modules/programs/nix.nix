{ inputs, pkgs, ... }:

{
  nix = {
    channel.enable = false;
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      auto-optimise-store = true;
    };
    optimise = {
      automatic = true;
    };

    registry.nixpkgs.flake = inputs.nixpkgs;
    registry.stable.flake = inputs.stable;
    nixPath = [ "nixpkgs=flake:nixpkgs" ];

    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 14d";
    };
  };
}
