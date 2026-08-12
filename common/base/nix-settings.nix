{
  inputs,
  lib,
  config,
  ...
}:

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
      # log-format = "bar-with-logs";

      experimental-features = [
        "nix-command"
        "flakes"
      ];

      connect-timeout = 5;

      build-dir = "/var/tmp/nix";
    };
  };

}
