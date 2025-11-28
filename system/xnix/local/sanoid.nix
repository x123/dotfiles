{config, ...}: {
  sops.secrets = {
    "truenas/ssh-priv" = {
      mode = "0400";
      owner = "syncoid";
      group = "syncoid";
    };
    "truenas/ssh-pub" = {
      mode = "0444";
      owner = "syncoid";
      group = "syncoid";
    };
  };

  services.sanoid = {
    enable = true;
    interval = "minutely";

    templates.production = {
      hourly = 72;
      daily = 30;
      monthly = 3;
      autoprune = true;
      autosnap = true;
    };

    # backup important datasets
    datasets."xnixtank/state" = {
      use_template = ["production"];
      recursive = true;
    };

    # ignore scratch / nix store
    datasets."xnixtank/scratch" = {
      autosnap = false;
    };
  };

  services.syncoid = {
    enable = true;
    interval = "*:00/15";

    commands = {
      "push-state" = {
        source = "xnixtank/state";
        target = "root@truenas.empire.internal:iron/backup-target/xnix/state";
        extraArgs = [
          "--recursive"
          "--create-bookmark"
          "--sshkey=${config.sops.secrets."truenas/ssh-priv".path}"
          "--sshoption=StrictHostKeyChecking=no"
          "--sshoption=UserKnownHostsFile=/dev/null"
        ];
      };
    };
  };
}
