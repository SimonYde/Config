{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkMerge readFile;
  inherit (config.home) username;

  csshacks = inputs.firefox-csshacks + "/chrome";
  firefox-profile = {
    extensions.packages = with pkgs.nur.repos.rycee.firefox-addons; [
      bitwarden
      darkreader
      floccus
      multi-account-containers
      readwise-highlighter
      sidebery
      ublock-origin
      vimium-c
      kagi-privacy-pass

      danish-dictionary
      danish-language-pack
    ];
    extensions.force = true;
    settings = {
      "extensions.pocket.enabled" = false;
      "extensions.update.autoUpdateDefault" = true;
      "extensions.update.enabled" = true;
      "extensions.autoDisableScopes" = 0;

      # Privacy
      "browser.contentblocking.category" = "custom";
      "privacy.trackingprotection.enabled" = true;
      "privacy.trackingprotection.socialtracking.enabled" = true;
      "privacy.trackingprotection.emailtracking.enabled" = true;
      "privacy.fingerprintingProtection" = true;

      "browser.laterrun.enabled" = true;
      "cookiebanners.service.mode" = 2;
      "cookiebanners.service.mode.privateBrowsing" = 2;
      "datareporting.healthreport.uploadEnabled" = false;
      "dom.security.https_only_mode" = true;
      "dom.security.https_only_mode_ever_enabled" = true;
      "extensions.getAddons.cache.enabled" = false;
      "extensions.getAddons.showPane" = false;
      "privacy.resistFingerprinting" = false;
      "media.peerconnection.enabled" = false; # remove WebRTC IP leak

      "privacy.history.custom" = true;

      "browser.formfill.enable" = false;
      "extensions.formautofill.addresses.enabled" = false;
      "extensions.formautofill.creditCards.enabled" = false;
      "signon.autofillForms" = false;
      "signon.rememberSignons" = false;

      # Networking and DNS
      "network.dns.disablePrefetch" = true;
      "network.http.referer.disallowCrossSiteRelaxingDefault.top_navigation" = true;
      "network.trr.uri" = "https://base.dns.mullvad.net/dns-query";
      "network.trr.custom_uri" = "https://base.dns.mullvad.net/dns-query";
      "network.predictor.enabled" = false;
      "network.prefetch-next" = false;

      # Look and feel
      "browser.compactmode.show" = true;
      "browser.uidensity" = 1;
      "intl.accept_languages" = "en,da";
      "intl.locale.requested" = "en-GB,da,fr,en-US";

      "browser.bookmarks.addedImportButton" = true;
      "browser.bookmarks.restore_default_bookmarks" = false;
      "browser.ml.chat.enabled" = true;
      "browser.ml.chat.provider" = "https://kagi.com/assistant";

      "browser.newtabpage.pinned" = "[]";
      "browser.startup.homepage" = "chrome://browser/content/blanktab.html";
      "browser.startup.page" = 3;

      "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
      "svg.context-properties.content.enabled" = true;
    };

    search = {
      default = "Kagi";
      privateDefault = "Kagi";
      force = true;

      engines = {
        "Kagi" = {
          urls = [
            {
              template = "https://kagi.com/search";
              params = [
                {
                  name = "q";
                  value = "{searchTerms}";
                }
              ];
            }
          ];
          icon = "https://kagi.com/asset/v2/favicon-16x16.png";
          definedAliases = [ "@k" ];
        };
      };
    };

    userChrome =
      readFile "${csshacks}/hide_tabs_toolbar_v2.css"
      + readFile "${csshacks}/privatemode_indicator_as_menu_button.css";

    extraConfig = readFile "${inputs.betterfox}/Fastfox.js";
  };
in
{
  syde.gui.browser = {
    name = "floorp";
    inherit (config.programs.floorp) package;
  };

  programs = {
    brave = {
      extensions = [
        { id = "nngceckbapebfimnlniiiahkandclblb"; } # Bitwarden
        { id = "jjhefcfhmnkfeepcpnilbbkaadhngkbi"; } # Readwise Highlighter
        { id = "dbepggeogbaibhgnhhndojpepiihcmeb"; } # Vimium
        { id = "clngdbkpkpeebahjckkjfobafhncgmne"; } # Stylus
        { id = "eimadpbcbfnmbkopoojfekhnkhdbieeh"; } # Dark Reader
        { id = "cdglnehniifkbagbbombnjghhcihifij"; } # Kagi Search
        { id = "mendokngpagmkejfpmeellpppjgbpdaj"; } # Kagi Privacy Pass
      ];
    };

    firefox.profiles.${username} = firefox-profile;

    floorp.profiles.${username} = firefox-profile;
  };
}
