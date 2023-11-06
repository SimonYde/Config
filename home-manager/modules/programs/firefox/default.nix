{ pkgs, ... }:

{
  syde.unfreePredicates = [
    "enhancer-for-youtube"
    "lastpass-password-manager"
  ];
  programs.firefox = {
    profiles.syde = {
      name = "syde";
      search = {
        default = "DuckDuckGo";
        force = true;
        engines = {
          "Arch Wiki" = {
            urls = [{
              template = "https://wiki.archlinux.org/index.php";
              params = [
                { name = "search"; value = "{searchTerms}"; }
              ];
            }];
            iconUpdateURL = "https://wiki.archlinux.org/favicon.ico";
            definedAliases = [ "!aw" ];
          };
          "Brave Search" = {
            urls = [{
              template = "https://search.brave.com/search";
              params = [
                { name = "q"; value = "{searchTerms}"; }
              ];
            }];
            iconUpdateURL = "https://cdn.search.brave.com/serp/v2/_app/immutable/assets/favicon-16x16.341beadf.png";
            definedAliases = [ "!b" ];
          };
          "Kagi" = {
            urls = [{
              template = "https://kagi.com/search";
              params = [
                { name = "q"; value = "{searchTerms}"; }
              ];
            }];
            iconUpdateURL = "https://assets.kagi.com/v1/favicon-16x16.png";
            definedAliases = [ "!k" ];
          };
          "Nix Packages" = {
            urls = [{
              template = "https://search.nixos.org/packages";
              params = [
                { name = "type"; value = "packages"; }
                { name = "query"; value = "{searchTerms}"; }
              ];
            }];
            icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
            definedAliases = [ "!np" ];
          };
          "NixOS Wiki" = {
            urls = [{
              template = "https://nixos.wiki/index.php";
              params = [
                { name = "search"; value = "{searchTerms}"; }
              ];
            }];
            iconUpdateURL = "https://nixos.wiki/favicon.png";
            updateInterval = 24 * 60 * 60 * 1000; # every day
            definedAliases = [ "!nw" ];
          };
          "Youtube" = {
            urls = [{
              template = "https://www.youtube.com/results";
              params = [
                { name = "search_query"; value = "{searchTerms}"; }
              ];
            }];
            iconUpdateURL = "https://www.youtube.com/s/desktop/fa273944/img/favicon_144x144.png";
            definedAliases = [ "!yt" ];
          };
          "Bing".metaData.hidden = true;
          "Wikipedia (en)".metaData.hidden = true;
          "Amazon.com".metaData.hidden = true;
          "Twitter.com".metaData.hidden = true;
        };
        order = [
          "DuckDuckGo"
          "Kagi"
        ];
      };

      settings = {
        # Searching
        "browser.search.region" = "DK";
        "browser.search.suggest.enabled" = false;

        # Privacy
        "browser.contentblocking.category" = "strict";
        "privacy.resistFingerprinting" = true;
        "privacy.fingerprintingProtection" = true;
        "privacy.trackingprotection.enabled" = true;
        "privacy.trackingprotection.socialtracking.enabled" = true;
        "app.shield.optoutstudies.enabled" = false;
        "browser.formfill.enable" = false;
        "dom.security.https_only_mode" = true;
        "dom.security.https_only_mode_ever_enabled" = true;
        "general.useragent.locale" = "en-US";
        "privacy.sanitize.pending" = ''[{"id":"shutdown","itemsToClear":["cache","formdata","downloads"],"options":{}}]'';
        "privacy.sanitize.sanitizeOnShutdown" = true;
        "privacy.clearOnShutdown.cookies" = false;
        "privacy.history.custom" = true;
        "privacy.clearOnShutdown.sessions" = false;
        "privacy.clearOnShutdown.history" = false;
        "places.history.enabled" = false;
        "signon.rememberSignons" = false;
        "browser.laterrun.enabled" = true;
        "datareporting.healthreport.uploadEnabled" = false;
        "extensions.pocket.enabled" = false;

        # Networking and DNS
        "network.dns.disablePrefetch" = true;
        "network.http.referer.disallowCrossSiteRelaxingDefault.top_navigation" = true;
        "network.trr.uri" = "https://dns.quad9.net/dns-query";
        "network.trr.mode" = 2;
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
        "browser.aboutConfig.showWarning" = false;
        "browser.uidensity" = 1;
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
      };


      extensions = with pkgs.nur.repos.rycee.firefox-addons; [
        export-cookies-txt
        ublock-origin
        cookie-autodelete
        istilldontcareaboutcookies
        darkreader
        enhancer-for-youtube
        sponsorblock
        multi-account-containers
        news-feed-eradicator
        sidebery
        lastpass-password-manager
        proton-pass
        vimium
        stylus
        firefox-color

        bypass-paywalls-clean
        # readwise-highlighter # doesn't exist yet
      ];
      userChrome = builtins.readFile ./userChrome.css;
      userContent = builtins.readFile ./userContent.css;
    };
  };
}
