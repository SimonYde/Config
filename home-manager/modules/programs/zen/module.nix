{ ... }:

let

  modulePath = [
    "programs"
    "zen"
  ];

  mkZenModule = import ./mkZenModule.nix;

in
{
  meta.maintainers = [ ];
  imports = [
    (mkZenModule {
      inherit modulePath;
      name = "Zen Browser";
      wrappedPackageName = "zen";
      unwrappedPackageName = "zen-unwrapped";
      visible = true;

      platforms.linux = {
        configPath = ".zen";
      };
      platforms.darwin = {
        configPath = "Library/Application Support/Zen";
      };
    })
  ];
}
