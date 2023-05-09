{ pkgs, config, ... }:

{
  programs.firefox = {
    profiles.syde = {
      name = "syde";
      search = {
        default = "DuckDuckGo";
        force = true;
        engines = {
          "Kagi" = {
            urls = [{ template = "https://kagi.com/search?q={searchTerms}";}];
          };
          "Bing".metaData.hidden = true;
          "Amazon".metaData.hidden = true;
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
        "browser.bookmarks.addedImportButton" = false;
        "browser.bookmarks.restore_default_bookmarks" = false;
        "browser.startup.homepage" = "chrome://browser/content/blanktab.html";
        "browser.startup.page" = 3;
        "browser.aboutConfig.showWarning" = false;
        "browser.uidensity" = 1;
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
      };


      /*extensions = with pkgs.nur.repos.rycee.firefox-addons; [
        ublock-origin
        cookie-autodelete
        darkreader
        enhancer-for-youtube
        #dualsub
        lastpass-password-manager
        multi-account-containers
        sidebery
        #bypass-paywalls-clean
        #i-still-dont-care-about-cookies
      ];*/

      
      userChrome = builtins.readFile ./userChrome.css;
    };
  };
}
