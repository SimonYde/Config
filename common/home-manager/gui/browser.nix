{
  config,
  inputs,
  lib,
  ...
}:
let
  inherit (config.syde.gui) browser;
  inherit (lib) mkMerge readFile;
  inherit (config.home) username;

  csshacks = inputs.firefox-csshacks + "/chrome";
  firefox-profile = {
    settings = {
      "extensions.pocket.enabled" = false;
      "extensions.update.autoUpdateDefault" = true;
      "extensions.update.enabled" = true;

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
      "intl.accept_languages" = "en,da";
      "intl.locale.requested" = "en-GB,da,fr,en-US";

      "browser.bookmarks.addedImportButton" = true;
      "browser.bookmarks.restore_default_bookmarks" = false;
      "browser.ml.chat.enabled" = true;
      "browser.ml.chat.provider" = "https://kagi.com/assistant?profile=gemini-2-5-flash";
      "browser.tabs.groups.enabled" = true;

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
      readFile "${csshacks}/window_control_placeholder_support.css"
      + readFile "${csshacks}/hide_tabs_toolbar.css"
      + readFile "${csshacks}/privatemode_indicator_as_menu_button.css"
      + readFile "${csshacks}/window_control_force_linux_system_style.css"
      + readFile "${csshacks}/overlay_sidebar_header.css";

    extraConfig = readFile "${inputs.betterfox}/Fastfox.js";
  };
in
{
  imports = [ inputs.zen-browser.homeModules.default ];

  xdg.mimeApps.defaultApplications =
    let
      browser-mime = { brave = "brave-browser"; }.${browser} or browser;
    in
    {
      "x-scheme-handler/http" = "${browser-mime}.desktop";
      "x-scheme-handler/https" = "${browser-mime}.desktop";
      "x-scheme-handler/chrome" = "${browser-mime}.desktop";
      "text/html" = "${browser-mime}.desktop";
      "image/svg" = "${browser-mime}.desktop";
      "application/x-extension-htm" = "${browser-mime}.desktop";
      "application/x-extension-html" = "${browser-mime}.desktop";
      "application/x-extension-shtml" = "${browser-mime}.desktop";
      "application/xhtml+xml" = "${browser-mime}.desktop";
      "application/x-extension-xhtml" = "${browser-mime}.desktop";
      "application/x-extension-xht" = "${browser-mime}.desktop";
    };

  programs = {
    brave = {
      extensions = [
        {
          id = "dcpihecpambacapedldabdbpakmachpb";
          updateUrl = "https://raw.githubusercontent.com/iamadamdev/bypass-paywalls-chrome/master/updates.xml";
        }
        { id = "bkkmolkhemgaeaeggcmfbghljjjoofoh"; } # Catppuccin theme
        { id = "jjhefcfhmnkfeepcpnilbbkaadhngkbi"; } # Readwise Highlighter
        { id = "dbepggeogbaibhgnhhndojpepiihcmeb"; } # Vimium
        { id = "clngdbkpkpeebahjckkjfobafhncgmne"; } # Stylus
        { id = "eimadpbcbfnmbkopoojfekhnkhdbieeh"; } # Dark Reader
        { id = "oocalimimngaihdkbihfgmpkcpnmlaoa"; } # Teleparty
        { id = "ghmbeldphafepmbegfdlkpapadhbakde"; } # Proton pass
        { id = "cdglnehniifkbagbbombnjghhcihifij"; } # Kagi Search
        { id = "mendokngpagmkejfpmeellpppjgbpdaj"; } # Kagi Privacy Pass
      ];
    };

    firefox.profiles.${username} = firefox-profile;

    zen-browser.profiles.${username} = {
      inherit (firefox-profile) search;
      settings = mkMerge [
        firefox-profile.settings

        {
          "zen.view.compact.animate-sidebar" = false;
          "zen.view.experimental-no-window-controls" = true;
          "zen.view.experimental-rounded-view" = false;
        }
      ];
    };
  };
}
