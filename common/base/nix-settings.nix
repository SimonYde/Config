{ inputs, ... }:

{
  nix = {
    registry = {
      nixpkgs.flake = inputs.nixpkgs;
      self.flake = inputs.self;
    };

    settings = {
      keep-going = true;
      show-trace = true;

      experimental-features = [
        "pipe-operator"
        "nix-command"
        "flakes"
        "auto-allocate-uids"
        "cgroups"
      ];

      extra-system-features = [ "uid-range" ];
      auto-allocate-uids = true;
      use-cgroups = true;

      # auto-optimise-store = true;
      # warn-dirty = false;
      # builders-use-substitutes = true;

      use-xdg-base-directories = true;
      log-lines = 9999;
      log-format = "bar-with-logs";

      connect-timeout = 30;
      initial-connect-timeout = 30;

      build-dir = "/var/tmp/nix";
    };
  };

}
