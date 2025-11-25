{
  config,
  lib,
  ...
}: let
  cfg = config.custom.system-nixos.services.fail2ban;

  # Merge ignoreIP with allowLocalNetworks
  finalIgnoreIP =
    cfg.ignoreIP
    ++ (lib.optionals cfg.allowLocalNetworks [
      "127.0.0.1/8"
      "::1/128"
    ]);
in {
  options = {
    custom.system-nixos.services.fail2ban = {
      enable = lib.mkOption {
        default = false;
        type = lib.types.bool;
        description = "Whether to enable fail2ban service with custom configuration";
      };

      ignoreIP = lib.mkOption {
        default = [];
        type = lib.types.listOf lib.types.str;
        description = "List of IP addresses/ranges to ignore";
        example = ["192.168.1.0/24" "10.0.0.1"];
      };

      allowLocalNetworks = lib.mkOption {
        default = false;
        type = lib.types.bool;
        description = "Whether to automatically ignore localhost networks (127.0.0.1/8, ::1/128)";
      };

      customFilters = lib.mkOption {
        default = {};
        type = lib.types.attrsOf lib.types.str;
        description = "Custom fail2ban filters to create in /etc/fail2ban/filter.d/";
        example = {
          "my-app" = ''
            [Definition]
            failregex = ^.*authentication failed for user.*from <HOST>$
          '';
        };
      };

      jails = lib.mkOption {
        default = {};
        type = lib.types.attrsOf (lib.types.submodule {
          options = {
            settings = lib.mkOption {
              type = lib.types.attrsOf lib.types.str;
              description = "Jail-specific settings";
            };
          };
        });
        description = "Fail2ban jail configurations (same structure as services.fail2ban.jails)";
        example = {
          sshd = {
            settings = {
              filter = "sshd";
              maxretry = "3";
              backend = "systemd";
            };
          };
        };
      };
    };
  };

  config = lib.mkIf (config.custom.system-nixos.enable && cfg.enable) {
    # Create custom filter files
    environment.etc =
      lib.mapAttrs' (name: content: {
        name = "fail2ban/filter.d/${name}.conf";
        value = {text = content;};
      })
      cfg.customFilters;

    # Configure fail2ban service
    services.fail2ban = lib.mkMerge [
      {
        enable = true;
        banaction = "nftables-allports[blocktype=drop]";
        banaction-allports = "nftables-allports[blocktype=drop]";
        ignoreIP = finalIgnoreIP;
        bantime = "10m";
        bantime-increment = {
          enable = true;
          formula = "ban.Time * math.exp(float(ban.Count+1)*banFactor)/math.exp(1*banFactor)";
          maxtime = "7d";
          overalljails = true;
        };
      }
      (lib.mkIf (cfg.jails != {}) {
        jails = cfg.jails;
      })
    ];
  };
}
