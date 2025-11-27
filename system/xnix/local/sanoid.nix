{config, ...}: {
  sops.secrets = {
    "truenas/ssh-priv" = {
      mode = "0400";
      owner = "root";
      group = "root";
    };
    "truenas/ssh-pub" = {
      mode = "0444";
      owner = "root";
      group = "root";
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
          "--sshoption=-i ${config.sops.secrets."truenas/ssh-priv".path}"
        ];
      };
    };
  };
}
