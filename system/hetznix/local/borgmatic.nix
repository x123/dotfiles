{
  config,
  pkgs,
  ...
}: {
  imports = [
    # uncomment once borgmatic working correctly
    ./borgmatic-hetznix-systemd-timer.nix
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
    "borg/hetznix" = {};
    "ssh/u413840-sub2" = {};
  };

  environment.systemPackages = [
    pkgs.borgmatic
    pkgs.xxHash
  ];

  services.borgmatic = {
    enable = true;
    # package = pkgs.borgmatic;
    configurations = {
      hetznix = {
        source_directories = [];
        repositories = [
          {
            "path" = "ssh://u413840-sub2@u413840.your-storagebox.de/./hetznix";
            "label" = "hetznix-storagebox";
          }
        ];
        patterns = [
          "R /"
          "! dev"
          "! proc"
          "! sys"
          "! var/run"
          "! run"
          "! mnt"
          "! tmp"
          "- root/src/nixpkgs"
          "- root/.cache"
          "- root/**/.cache"
          "- root/.config/*/Cache"
          "- home/*/.cache"
          "- home/*/**/.cache"
          "- home/*/.config/*/Cache"
          "- var/lib/mastodon/public-system/cache"
        ];
        postgresql_databases = [
          {
            name = "all";
            username = "postgres";
            format = "custom";
            psql_command = "${pkgs.postgresql}/bin/psql";
            pg_dump_command = "${pkgs.postgresql}/bin/pg_dump";
            pg_restore_command = "${pkgs.postgresql}/bin/pg_restore";
          }
        ];
        retries = 5;
        retry_wait = 5;
        ssh_command = "${pkgs.openssh}/bin/ssh -p 23 -i ${config.sops.secrets."ssh/u413840-sub2".path}";
        encryption_passcommand = "${pkgs.coreutils}/bin/cat ${config.sops.secrets."borg/hetznix".path}";
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
        uptime_kuma = {
          push_url = "https://kuma.boxchop.city/api/push/HrvRMPBdfr";
          states = ["start" "finish" "fail"];
        };
        keep_daily = 7;
        keep_weekly = 4;
        keep_monthly = 6;
        keep_yearly = 1;
      };
    };
  };
}
