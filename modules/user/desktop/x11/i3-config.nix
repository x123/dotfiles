{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.custom;
  xset = "${pkgs.xorg.xset}/bin/xset";
  i3lock-dpms = "${pkgs.writeShellScript "i3lock-dpms" ''
    set -euo pipefail
    revert() {
      ${xset} dpms 0 0 0
    }
    trap revert HUP INT TERM
    ${xset} +dpms dpms 5 5 5
    ${pkgs.i3lock}/bin/i3lock -n -c 000000
    revert
  ''}";
in {
  imports = [];

  options = {
    custom.desktop.x11.i3 = {
      enable = lib.mkOption {
        default = false;
        type = lib.types.bool;
        description = "Whether to enable i3.";
      };
    };
    custom.desktop.i3status-rust = {
      battery.enable = lib.mkOption {
        default = false;
        type = lib.types.bool;
        description = "Whether to enable battery monitoring in i3status-rust";
      };
      nvidia.enable = lib.mkOption {
        default = false;
        type = lib.types.bool;
        description = "Whether to enable nvidia in i3status-rust";
      };

      temperature = {
        enable = lib.mkOption {
          default = false;
          type = lib.types.bool;
          description = "Whether to enable temperature monitoring in i3status-rust";
        };
        chip = lib.mkOption {
          default = "";
          type = lib.types.str;
          description = "What chip type to enable for the generic temperature monitor.";
        };
        inputs = lib.mkOption {
          default = [];
          type = lib.types.listOf lib.types.str;
          description = "What inputs to use (e.g., [ \"AMD TSI Addr 98h\" ]";
        };
      };
    };
  };

  config =
    lib.mkIf (
      config.custom.desktop.enable
      && config.custom.desktop.x11.i3.enable
      && !pkgs.stdenv.isDarwin
    ) {
      home.packages = builtins.attrValues {
        inherit
          (pkgs)
          blueman
          dunst
          feh
          i3status-rust
          networkmanagerapplet
          redshift
          ;
        inherit (pkgs.xfce) thunar;
      };

      programs = {
        rofi = {
          enable = true;
          theme = "${pkgs.rofi}/share/rofi/themes/Arc-Dark.rasi";
          terminal = "ghostty";
          extraConfig = {
            dpi = 0;
            modes = "window,drun,ssh,run,combi";
            combi-modes = "window,ssh,drun,run";
          };
        };

        autorandr = {
          enable = true;
          profiles = {
            "home" = {
              fingerprint.DP-0 = "00ffffffffffff000469b127b98b010027180104a53c2278064ce1a55850a0230b505400000001010101010101010101010101010101565e00a0a0a029503020350056502100001a000000ff002341534d764c30494c30655064000000fd001e961ed236010a202020202020000000fc00524f47205047323738510a202001fb02030a01654b040001015a8700a0a0a03b503020350056502100001a5aa000a0a0a046503020350056502100001a6fc200a0a0a055503020350056502100001a74d20016a0a009500410110056502100001e1c2500a0a0a011503020350056502100001a000000000000000000000000000000000000000000000000000000af";
              config = {
                DP-0 = {
                  enable = true;
                  primary = true;
                  crtc = 0;
                  mode = "2560x1440";
                  rate = "144.00";
                };
              };
            };
          };
        };

        i3status-rust = {
          enable = true;
          bars = {
            default = {
              icons = "material-nf";
              blocks =
                [
                  {
                    block = "sound";
                  }
                  {
                    alert = 10.0;
                    block = "disk_space";
                    info_type = "available";
                    interval = 60;
                    path = "/";
                    warning = 20.0;
                  }
                  {
                    block = "memory";
                    format = " $icon $mem_used_percents ";
                    format_alt = " $icon $mem_used ";
                  }
                  {
                    block = "load";
                    format = " $icon $1m ";
                    interval = 1;
                  }
                ]
                ++ (
                  if cfg.desktop.i3status-rust.temperature.enable
                  then [
                    {
                      block = "temperature";
                      chip = cfg.desktop.i3status-rust.temperature.chip;
                      inputs = cfg.desktop.i3status-rust.temperature.inputs;
                      interval = 1;
                      idle = 55;
                    }
                  ]
                  else []
                )
                ++ (
                  if cfg.desktop.i3status-rust.battery.enable
                  then [
                    {
                      block = "battery";
                      format = " $icon $percentage {$time |}";
                      full_format = " $icon $percentage {$time |}";
                      interval = 1;
                      missing_format = "";
                      # device = "BAT0";
                    }
                  ]
                  else []
                )
                ++ (
                  if cfg.desktop.i3status-rust.nvidia.enable
                  then [
                    {
                      block = "nvidia_gpu";
                      gpu_id = 0;
                      format = " $icon  RTX4090 $power $temperature $utilization $temperature ";
                      interval = 1;
                    }
                  ]
                  else []
                )
                ++ [
                  {
                    block = "time";
                    format = " $timestamp.datetime(f:'Week %W | %A | %Y-%m-%d %H:%M:%S') ";
                    interval = 1;
                  }
                ];
              settings = {
                theme = {
                  theme = "nord-dark";
                };
              };
            };
          };
        };
      };

      services = {
        blueman-applet.enable = true;
        network-manager-applet.enable = true;
        picom.enable = true;
      };

      xsession.enable = true;
      xsession.windowManager.i3 = let
        my-modifier = "Mod4"; #Mod1 is alt
        # background = "${pkgs.plasma-workspace-wallpapers}/share/wallpapers/Path/contents/images/2560x1600.jpg";
        # fetch background from web
        # background = pkgs.fetchurl {
        # url = "https://raw.githubusercontent.com/NixOS/nixos-artwork/03c6c20be96c38827037d2238357f2c777ec4aa5/wallpapers/nix-wallpaper-dracula.png";
        # sha256 = "SykeFJXCzkeaxw06np0QkJCK28e0k30PdY8ZDVcQnh4=";
        # };
      in {
        enable = true;
        config = {
          startup =
            [
              {command = "${pkgs.autorandr}/bin/autorandr -l home";}
              {command = "${pkgs.xorg.setxkbmap}/bin/setxkbmap -option compose:ralt";}
              #{command = "${pkgs.feh}/bin/feh --bg-fill ${background}";}
              {command = "${pkgs.dunst}/bin/dunst &";}
              {command = "${pkgs.picom}/bin/picom --daemon";}
              {command = "${pkgs.i3}/bin/i3-msg workspace 1";}
              {command = "${pkgs.redshift}/bin/redshift -l 55.7:12.6 -t 5700:3600 -P -g 1.0 -m randr -v";}
              {command = "${pkgs.networkmanagerapplet}/bin/nm-applet &";}
              {command = "${pkgs.blueman}/bin/blueman-applet &";}
            ]
            ++ (
              if pkgs.stdenv.isDarwin || pkgs.stdenv.hostPlatform.system == "aarch64-linux"
              then []
              else [
                {command = "${pkgs.dropbox}/bin/dropbox &";}
              ]
            );
          modifier = my-modifier;
          terminal = "ghostty";
          #terminal = "${pkgs.alacritty}/bin/alacritty";
          window = {
            hideEdgeBorders = "smart";
            titlebar = false;
          };
          bars = [
            {
              fonts = {
                names = ["CodeNewRoman Nerd Font"];
                size = 12.0;
              };
              mode = "dock";
              hiddenState = "show";
              statusCommand = "${pkgs.i3status-rust}/bin/i3status-rs ~/.config/i3status-rust/config-default.toml";
              position = "bottom";
              trayOutput = "primary";
              workspaceButtons = true;
            }
          ];
          keybindings = lib.mkOptionDefault {
            "${my-modifier}+Shift+l" = "exec ${i3lock-dpms}";
            "${my-modifier}+Tab" = "exec ${pkgs.rofi}/bin/rofi -show window";
            "${my-modifier}+d" = "exec ${pkgs.rofi}/bin/rofi -show combi";
            "${my-modifier}+Shift+s" = "sticky toggle";
          };
          focus = {
            followMouse = false;
            mouseWarping = true;
          };
        };
      };
    };
}
