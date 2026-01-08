{ inputs, ... }:

{
  nix = {
    registry = {
      nixpkgs.flake = inputs.nixpkgs;
      self.flake = inputs.self;
    };

    settings = {
      auto-optimise-store = true;
      keep-going = true;
      show-trace = true;
      warn-dirty = false;
      builders-use-substitutes = true;
      use-xdg-base-directories = true;
      log-lines = 9999;

      experimental-features = [
        "nix-command"
        "flakes"
      ];

      substituters = [
        "https://cache.nixos.org"
        "https://nix-community.cachix.org"
      ];

      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];

      connect-timeout = 5;

      build-dir = "/var/tmp/nix";
    };
  };
}
