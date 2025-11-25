{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./borgmatic-xnix-systemd-timer.nix
  ];

  sops.secrets = {
    "borg/xnix" = {};
    "ntfy/user" = {};
    "ntfy/pass" = {};
  };

  home.packages = [
    pkgs.borgmatic
    pkgs.xxHash
  ];

  programs.borgmatic = {
    enable = true;
    backups = {
      x-at-xnix-home = {
        storage.encryptionPasscommand = "${pkgs.coreutils}/bin/cat ${config.sops.secrets."borg/xnix".path}";
        consistency = {
          checks = [
            {
              name = "repository";
              frequency = "1 weeks";
            }
            {
              name = "archives";
              frequency = "2 weeks";
            }
            {
              name = "extract";
              frequency = "3 weeks";
            }
            {
              name = "data";
              frequency = "4 weeks";
            }
          ];
          # doesn't currently work due do dependency on xxh64sum. pkgs.xxHash
          # provides  xxhsum -H64
          # extraConfig = {
          #   checks = [
          #     {
          #       name = "spot";
          #       count_tolerance_percentage = 10;
          #       data_sample_percentage = 1;
          #       data_tolerance_percentage = 0.5;
          #       # frequency = "4 weeks";
          #     }
          #   ];
          # };
        };
        hooks.extraConfig = {
          ntfy = {
            topic = "borgmatic-xnix";
            server = "https://ntfy.boxchop.city:8883";
            username = "borgmatic-xnix";
            password = "strata-potentials-expressly";
            start = {
              title = "borgmatic: backup started on xnix";
              message = "Watch this space...";
              tags = "borgmatic";
              priority = "min";
            };
            finish = {
              title = "borgmatic: backup completed successfully on xnix";
              message = "Nice!";
              tags = "borgmatic,+1";
              priority = "min";
            };
            fail = {
              title = "borgmatic: backup failed on xnix";
              message = "You should probably fix it";
              tags = "borgmatic,-1,skull";
              priority = "max";
            };
            states = ["start" "finish" "fail"];
          };
        };
        retention = {
          keepDaily = 7;
          keepWeekly = 4;
          keepMonthly = 6;
          keepYearly = 1;
        };
        location = {
          repositories = [
            {
              "path" = "/mnt/xdata/borg";
              "label" = "local";
            }
          ];

          patterns = [
            "R ${config.home.homeDirectory}"
            "! home/x/mnt" # never recurse into mnt
            "- home/x/.cache"
            "- home/x/**/.cache"
            "- home/x/.config/*/Cache"
            "- home/x/invokeai/models/.cache"
            "- home/x/src/nixpkgs"
          ];
        };
      };
    };
  };
}
