{config, ...}: {
  sops.secrets."borg/xnix" = {
    mode = "0400";
    owner = config.users.users.x.name;
    group = config.users.users.x.group;
  };

  services.borgbackup.jobs = {
    xnixBackup = {
      user = config.users.users.x.name;
      group = config.users.users.x.group;
      paths = ["${config.users.users.x.home}"];
      exclude = [
        "/nix"
        "'**/.cache'"
        "${config.users.users.x.home}/borg"
        "${config.users.users.x.home}/invokeai/models"
      ];
      doInit = false;
      repo = "/mnt/xdata/borg";
      encryption = {
        mode = "repokey-blake2";
        passCommand = "cat ${config.sops.secrets."borg/xnix".path}";
      };
      compression = "auto,lzma";
      startAt = "daily";
    };
  };
}
