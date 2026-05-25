{ inputs, ... }:

{
  imports = [
    inputs.ncro.nixosModules.default
  ];

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
      log-format = "multiline-with-logs";

      experimental-features = [
        "nix-command"
        "flakes"
      ];

      substituters = [
        "http://localhost:10100"
      ];

      connect-timeout = 5;

      build-dir = "/var/tmp/nix";
    };
  };

  services.ncro = {
    enable = true;

    settings = {
      server = {
        listen = ":10100";
      };

      upstreams = [
        {
          url = "https://cache.nixos.org";
          priority = 10;
        }
        {
          url = "https://nix-community.cachix.org";
          priority = 20;
        }
        {
          url = "https://cache.garnix.io";
          priority = 30;
        }
        {
          url = "https://attic.xuyh0120.win/lantian";
          priority = 40;
        }
      ];
    };
  };
}
