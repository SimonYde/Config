{
  config,
  pkgs,
  lib,
  username,
  inputs,
  ...
}:
let
  inherit (lib)
    mkIf
    getExe
    head
    splitString
    ;
  inherit (config.syde) server email;

  cfg = config.services.nextcloud;
in
{
  config = mkIf cfg.enable {
    age.secrets = {
      nextcloudAdminPassword = {
        file = "${inputs.secrets}/nextcloudAdminPassword.age";
      };
      nextcloudClientSecret = {
        file = "${inputs.secrets}/nextcloudClientSecret.age";
        owner = "nextcloud";
      };
      nextcloudSecretFile = {
        file = "${inputs.secrets}/nextcloudSecretFile.age";
        owner = "nextcloud";
      };
    };

    users.users.nextcloud.extraGroups = [
      "render"
      "video"
      server.group
    ];

    environment.systemPackages = [ pkgs.perl ];

    services = {
      nextcloud = {
        package = pkgs.nextcloud32;
        hostName = "cloud.${server.baseDomain}";
        datadir = "/mnt/tank/nextcloud";
        database.createLocally = true;
        secretFile = config.age.secrets.nextcloudSecretFile.path;

        configureRedis = true;
        caching.redis = true;
        https = true;

        notify_push = {
          enable = true;
          bendDomainToLocalhost = true;
        };

        maxUploadSize = "24G";

        appstoreEnable = true;
        autoUpdateApps.enable = false;
        extraAppsEnable = true;
        extraApps = {
          inherit (cfg.package.packages.apps)
            bookmarks
            calendar
            collectives
            contacts
            cookbook
            groupfolders
            memories
            music
            notes
            tasks
            previewgenerator
            richdocuments
            user_oidc
            ;
        };

        phpOptions = {
          "opcache.interned_strings_buffer" = "16";
          "opcache.revalidate_freq" = "5";
          "opcache.jit" = "1255";
          "opcache.jit_buffer_size" = "128M";
        };

        settings = {
          overwriteprotocol = "https";
          overwritehost = "cloud.${server.baseDomain}";
          overwrite.cli.url = "https://cloud.${server.baseDomain}";

          mail_smtpmode = "smtp";
          mail_smtphost = email.smtpServer;
          mail_smtpauth = true;
          mail_smtpport = 587;
          mail_from_address = head (splitString "@" email.fromAddress);
          mail_domain = server.baseDomain;

          default_phone_region = "DK";

          forwarded_for_headers = [
            "HTTP_X_FORWARDED_FOR"
          ];

          enabledPreviewProviders = [
            "OC\\Preview\\BMP"
            "OC\\Preview\\GIF"
            "OC\\Preview\\JPEG"
            "OC\\Preview\\Krita"
            "OC\\Preview\\MarkDown"
            "OC\\Preview\\MP3"
            "OC\\Preview\\OpenDocument"
            "OC\\Preview\\PNG"
            "OC\\Preview\\TXT"
            "OC\\Preview\\XBitmap"
            "OC\\Preview\\HEIC"
          ];

          "memories.exiftool" = "${getExe pkgs.exiftool}";
          "memories.vod.ffmpeg" = "${pkgs.ffmpeg-headless}/bin/ffmpeg";
          "memories.vod.ffprobe" = "${pkgs.ffmpeg-headless}/bin/ffprobe";
          preview_ffmpeg_path = "${pkgs.ffmpeg-headless}/bin/ffmpeg";
        };

        config = {
          dbtype = "pgsql";
          adminuser = username;
          adminpassFile = config.age.secrets.nextcloudAdminPassword.path;
        };
      };

      postgresql.enable = true;
    };

    syde.services.fail2ban.jails.nextcloud = {
      serviceName = "phpfpm-nextcloud";
      failRegex = "^.*Login failed:.*(Remote IP: <HOST>).*$";
    };

    systemd.services.nextcloud-cron.path = [ pkgs.perl ];

    systemd.services.nextcloud-config-oauth2 =
      let
        occ = lib.getExe' config.services.nextcloud.occ "nextcloud-occ";
      in
      {
        wantedBy = [ "multi-user.target" ];
        after = [
          "nextcloud-setup.service"
        ];
        script = ''
          ${occ} user_oidc:provider Kanidm \
              --clientid="nextcloud" \
              --clientsecret="$CLIENT_SECRET" \
              --discoveryuri="https://auth.simonyde.com/oauth2/openid/nextcloud/.well-known/openid-configuration" \
              --scope="openid groups email profile" \
              --unique-uid=0 \
              --group-provisioning=1 \
              --extra-claims="account_role" \
              --mapping-groups="account_role" \
              --mapping-uid="preferred_username" \
              --no-interaction
          # ${occ} config:app:set user_oidc allow_multiple_user_backends --value=0 # Disables other login methods
        '';

        serviceConfig = {
          EnvironmentFile = config.age.secrets.nextcloudClientSecret.path;
          Type = "oneshot";
        };
      };
  };
}
