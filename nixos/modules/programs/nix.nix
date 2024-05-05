{ inputs, ... }:
{
  nix = {
    channel.enable = true; # TODO: remove when nixPath is fixed for flake only
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      warn-dirty = false;
      auto-optimise-store = true;
    };
    optimise = {
      automatic = true;
    };

    registry.nixpkgs.flake = inputs.nixpkgs;
    registry.stable.flake = inputs.stable;
    nixPath = [ "nixpkgs=flake:nixpkgs" ];

    gc = {
      automatic = false;
      dates = "weekly";
      options = "--delete-older-than 14d";
    };
  };
}
