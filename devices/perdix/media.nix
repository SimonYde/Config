{ ... }:

{
  users = {
    groups.media = { };
    users.media = {
      description = "media utility user";
      isSystemUser = true;
      group = "media";
      home = "/var/lib/qbittorrent";
    };
  };
}
