{ lib, ... }:

with lib;

let

  modulePath = [
    "programs"
    "zen"
  ];

  moduleName = concatStringsSep "." modulePath;

  mkZenModule = import ./mkZenModule.nix;

in
{
  meta.maintainers = [
    maintainers.rycee
    maintainers.kira-bruneau
    hm.maintainers.bricked
  ];

  imports = [
    (mkZenModule {
      inherit modulePath;
      name = "Zen Browser";
      wrappedPackageName = "zen";
      unwrappedPackageName = "zen-unwrapped";
      visible = true;

      platforms.linux = rec {
        vendorPath = ".zen";
        configPath = "${vendorPath}";
      };
      platforms.darwin = {
        vendorPath = "Library/Application Support/Zen";
        configPath = "Library/Application Support/Zen";
      };
    })

    (mkRemovedOptionModule (modulePath ++ [ "extensions" ]) ''

      Extensions are now managed per-profile. That is, change from

        ${moduleName}.extensions = [ foo bar ];

      to

        ${moduleName}.profiles.myprofile.extensions = [ foo bar ];'')
    (mkRemovedOptionModule (
      modulePath ++ [ "enableAdobeFlash" ]
    ) "Support for this option has been removed.")
    (mkRemovedOptionModule (
      modulePath ++ [ "enableGoogleTalk" ]
    ) "Support for this option has been removed.")
    (mkRemovedOptionModule (
      modulePath ++ [ "enableIcedTea" ]
    ) "Support for this option has been removed.")
  ];
}
