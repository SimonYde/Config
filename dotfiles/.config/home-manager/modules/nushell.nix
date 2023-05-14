{pkgs, ...}:

{
  programs.nushell = {
    package = pkgs.unstable.nushell;
  };
}
