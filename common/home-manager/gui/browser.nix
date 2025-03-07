{
  config,
  pkgs,
  inputs,
  lib,
  ...
}:
let
  inherit (config.syde.gui) browser;
  inherit (lib) readFile;
  inherit (inputs) betterfox;
in
{
  home.packages = [ pkgs.zen-browser ];

  xdg.mimeApps.defaultApplications = {
    "x-scheme-handler/http" = "${browser}.desktop";
    "x-scheme-handler/https" = "${browser}.desktop";
    "x-scheme-handler/chrome" = "${browser}.desktop";
    "text/html" = "${browser}.desktop";
    "image/svg" = "${browser}.desktop";
    "application/x-extension-htm" = "${browser}.desktop";
    "application/x-extension-html" = "${browser}.desktop";
    "application/x-extension-shtml" = "${browser}.desktop";
    "application/xhtml+xml" = "${browser}.desktop";
    "application/x-extension-xhtml" = "${browser}.desktop";
    "application/x-extension-xht" = "${browser}.desktop";
  };

  programs.brave = {
    extensions = [
      { id = "fhcgjolkccmbidfldomjliifgaodjagh"; } # Cookie AutoDelete
      { id = "jjhefcfhmnkfeepcpnilbbkaadhngkbi"; } # Readwise Highlighter
      { id = "dbepggeogbaibhgnhhndojpepiihcmeb"; } # Vimium
      { id = "clngdbkpkpeebahjckkjfobafhncgmne"; } # Stylus
      { id = "fjcldmjmjhkklehbacihaiopjklihlgg"; } # News Feed Eradicator
      { id = "eimadpbcbfnmbkopoojfekhnkhdbieeh"; } # Dark Reader
      { id = "oocalimimngaihdkbihfgmpkcpnmlaoa"; } # Teleparty
      { id = "hdokiejnpimakedhajhdlcegeplioahd"; } # Lastpass
    ];
  };

  programs.firefox.profiles.${config.home.username} = {
    search = {
      default = "Kagi";
      privateDefault = "Kagi";
      force = true;

      engines = {
        "Google".metaData.alias = "@g";
        "Bing".metaData.hidden = true;
        "Wikipedia (en)".metaData.hidden = true;
        "Amazon.com".metaData.hidden = true;
        "Twitter.com".metaData.hidden = true;

        "Arch Wiki" = {
          urls = [
            {
              template = "https://wiki.archlinux.org/index.php";
              params = [
                {
                  name = "search";
                  value = "{searchTerms}";
                }
              ];
            }
          ];
          iconUpdateURL = "https://wiki.archlinux.org/favicon.ico";
          definedAliases = [ "@aw" ];
        };

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
          iconUpdateURL = "https://kagi.com/asset/v2/favicon-16x16.png";
          definedAliases = [ "@k" ];
        };

        "Nix Packages" = {
          urls = [
            {
              template = "https://search.nixos.org/packages";
              params = [
                {
                  name = "channel";
                  value = "unstable";
                }
                {
                  name = "type";
                  value = "packages";
                }
                {
                  name = "query";
                  value = "{searchTerms}";
                }
              ];
            }
          ];
          icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
          definedAliases = [ "@np" ];
        };

        "NixOS Options" = {
          urls = [
            {
              template = "https://search.nixos.org/options";
              params = [
                {
                  name = "channel";
                  value = "unstable";
                }
                {
                  name = "query";
                  value = "{searchTerms}";
                }
              ];
            }
          ];
          icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
          definedAliases = [ "@no" ];
        };

        "NixOS Wiki" = {
          urls = [
            {
              template = "https://wiki.nixos.org/w/index.php";
              params = [
                {
                  name = "title";
                  value = "Special:Search";
                }
                {
                  name = "search";
                  value = "{searchTerms}";
                }
              ];
            }
          ];
          icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
          definedAliases = [ "@nw" ];
        };
      };
    };

    settings = {
      # Searching
      "browser.search.region" = "DK";
      "browser.search.suggest.enabled" = false;
      # Privacy
      "app.shield.optoutstudies.enabled" = false;
      "browser.contentblocking.category" = "strict";
      "browser.formfill.enable" = false;
      "browser.laterrun.enabled" = true;
      "cookiebanners.service.mode" = 2;
      "cookiebanners.service.mode.privateBrowsing" = 2;
      "datareporting.healthreport.uploadEnabled" = false;
      "dom.security.https_only_mode" = true;
      "dom.security.https_only_mode_ever_enabled" = true;
      "extensions.getAddons.cache.enabled" = false;
      "extensions.getAddons.showPane" = false;
      "extensions.pocket.enabled" = false;
      "extensions.update.autoUpdateDefault" = false;
      "extensions.update.enabled" = false;
      "extensions.autoDisableScopes" = 0;
      "general.useragent.locale" = "en-US";
      "places.history.enabled" = true;
      "privacy.clearOnShutdown.cookies" = false;
      "privacy.clearOnShutdown.history" = false;
      "privacy.clearOnShutdown.sessions" = false;
      "privacy.fingerprintingProtection" = true;
      "privacy.history.custom" = true;
      "privacy.resistFingerprinting" = false;
      "privacy.sanitize.pending" = # json
        ''
          [{"id":"shutdown","itemsToClear":["cache","formdata","downloads"],"options":{}}]
        '';
      "privacy.sanitize.sanitizeOnShutdown" = true;
      "privacy.trackingprotection.enabled" = true;
      "privacy.trackingprotection.socialtracking.enabled" = true;
      "media.peerconnection.enabled" = false; # remove WebRTC IP leak

      "signon.autofillForms" = false;
      "signon.rememberSignons" = false;

      # Networking and DNS
      "network.dns.disablePrefetch" = true;
      "network.http.referer.disallowCrossSiteRelaxingDefault.top_navigation" = true;
      "network.trr.uri" = "https://base.dns.mullvad.net/dns-query";
      # "network.trr.mode" = 3;
      "network.predictor.enabled" = false;
      "network.prefetch-next" = false;

      # Look and feel
      "trailhead.firstrun.didSeeAboutWelcome" = true;
      "doh-rollout.doneFirstRun" = true;
      "app.normandy.first_run" = false;
      "devtools.everOpened" = true;
      "browser.bookmarks.addedImportButton" = true;
      "browser.bookmarks.restore_default_bookmarks" = false;
      "browser.startup.homepage" = "chrome://browser/content/blanktab.html";
      "browser.startup.page" = 3;
      "browser.newtabpage.pinned" = "[]";
      "browser.aboutConfig.showWarning" = false;
      "browser.uidensity" = 1;
      "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
      "svg.context-properties.content.enabled" = true;
    };

    userChrome =
      let
        csshacks = inputs.firefox-csshacks + "/chrome";
      in
      readFile "${csshacks}/window_control_placeholder_support.css"
      + readFile "${csshacks}/hide_tabs_toolbar.css"
      + readFile "${csshacks}/privatemode_indicator_as_menu_button.css"
      + readFile "${csshacks}/window_control_force_linux_system_style.css"
      + readFile "${csshacks}/overlay_sidebar_header.css";
    extraConfig = readFile "${betterfox}/Fastfox.js";
  };
}
