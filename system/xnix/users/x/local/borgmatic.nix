{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./borgmatic-xnix-systemd-timer.nix
  ];

  # nixpkgs.overlays = [
  #   (
  #     final: prev: {
  #       unstable-small = import inputs.nixpkgs-unstable-small {
  #         system = "x86_64-linux";
  #       };
  #     }
  #   )
  # ];

  sops.secrets = {
    "borg/xnix" = {};
    "ntfy/user" = {};
    "ntfy/pass" = {};
    "ssh/u413840-sub1" = {};
    "ssh/u413840-sub2" = {};
  };

  home.packages =
    [
      pkgs.borgmatic
      pkgs.borgbackup
      pkgs.xxHash
    ]
    ++ [
      (
        pkgs.writeShellScriptBin
        "borgmount-hetznix"
        ''
          set -euo pipefail

          ${pkgs.borgbackup}/bin/borg mount -o ignore_permissions --rsh "${pkgs.openssh}/bin/ssh -p 23 -i ${config.sops.secrets."ssh/u413840-sub2".path}" "ssh://u413840-sub2@u413840.your-storagebox.de/./hetznix" ${config.home.homeDirectory}/mnt/borgmount
        ''
      )
      (
        pkgs.writeShellScriptBin
        "borgumount"
        ''
          set -euo pipefail

          ${pkgs.borgbackup}/bin/borg umount ${config.home.homeDirectory}/mnt/borgmount
        ''
      )
    ];

  programs.borgmatic = {
    enable = true;
    package = pkgs.borgmatic;
    backups = {
      x-at-xnix-home = {
        storage = {
          extraConfig = {
            retries = 5;
            retry_wait = 5;
            ssh_command = "${pkgs.openssh}/bin/ssh -p 23 -i ${config.sops.secrets."ssh/u413840-sub1".path}";
          };
          encryptionPasscommand = "${pkgs.coreutils}/bin/cat ${config.sops.secrets."borg/xnix".path}";
        };
        consistency = {
          checks = [
            {
              name = "repository";
              frequency = "1 weeks";
            }
            # {
            #   name = "archives";
            #   frequency = "2 weeks";
            # }
            # {
            #   name = "extract";
            #   frequency = "3 weeks";
            # }
            # {
            #   name = "data";
            #   frequency = "4 weeks";
            # }
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
            server = "https://ntfy.nixlink.net";
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
          uptime_kuma = {
            push_url = "https://kuma.nixlink.net/api/push/UvJTTCFLgp";
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
              "path" = "ssh://u413840-sub1@u413840.your-storagebox.de/./xnix";
              "label" = "xnix-storagebox";
            }
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
            "- home/x/priv/t"
            "- home/x/priv/.x"
          ];
        };
      };
    };
  };
}
