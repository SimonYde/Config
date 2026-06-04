{
  inputs,
  lib,
  config,
  ...
}:

{
  imports = [ inputs.ncro.nixosModules.default ];

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
      log-format = "bar-with-logs";

      experimental-features = [
        "nix-command"
        "flakes"
      ];

      substituters = lib.mkForce [
        "http://localhost${config.services.ncro.settings.server.listen}"
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
          public_key = "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY=";
        }
        {
          url = "https://nix-community.cachix.org";
          priority = 20;
          public_key = "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs=";
        }
        {
          url = "https://attic.xuyh0120.win/lantian";
          priority = 30;
          public_key = "lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc=";
        }
      ];
    };
  };
}
