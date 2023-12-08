{ pkgs, ... }:

{
  nix = {
    settings = {
      substituters = [
        "https://cuda-maintainers.cachix.org"
        "https://helix.cachix.org"
      ];
      trusted-public-keys = [
        "cuda-maintainers.cachix.org-1:0dq3bujKpuEPMCX6U4WylrUDZ9JyUG0VpVZa7CNfq5E="
        "helix.cachix.org-1:ejp9KQpR1FBI2onstMQ34yogDm4OgU2ru6lIwPvuCVs="
      ];
    };
  };

  environment.systemPackages = with pkgs; [
    cachix
  ];
}
