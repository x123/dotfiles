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
              fingerprint.DP-0 = "00ffffffffffff0006b3f2320101010124220104b54628783b0ad5af4e3eb5240e5054254a008140818081c0a940d1c00101010101014dd000a0f0703e8030203500bb8b2100001a000000fd0c30f0ffffea010a202020202020000000fc00504733325543444d0a20202020000000ff0053394c4d51533032363433370a02fb020344f154767561605f5e5d3f40101f2221200413121103022309070783010000e305c000e60605018b4d01e200ea741a0000030330f000a08b014d01f0000000008900565e00a0a0a0295030203500bb8b2100001ab8bc0050a0a0555008206800bb8b2100001a0000000000000000000000000000000000000000000000eb7012790300030164ca9c0104ff099f002f801f009f05b20002000400ceac0104ff0e9f006f801f006f087e0076000400e7610104ff0e9f002f801f006f08680002000400ef8e0304ff0e9f002f801f006f080c01020004005fe400047f07b3003f803f0037044f0002000400000000000000000000000000000000000000e490";
              config = {
                DP-0 = {
                  enable = true;
                  primary = true;
                  crtc = 0;
                  mode = "3840x2160";
                  rate = "240.02";
                };
              };
            };
          };
        };

        i3status-rust = {
          enable = true;
          bars = {
            default = {
              icons = "awesome6";
              blocks =
                [
                  {
                    block = "sound";
                    # format = " $icon $output_description {$volume.eng(w:2) |}"; # show output description
                    headphones_indicator = true;
                  }
                  {
                    block = "notify";
                    driver = "dunst";
                    format = " $icon {($notification_count.eng(w:1)) |}";
                    click = [
                      {
                        button = "left";
                        action = "toggle_paused";
                      }
                      {
                        button = "right";
                        action = "show";
                      }
                    ];
                  }
                  {
                    alert = 5.0;
                    block = "disk_space";
                    info_type = "available";
                    interval = 60;
                    path = "/";
                    warning = 10.0;
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
                      idle = 60;
                      info = 75;
                      warning = 85;
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
                    format = " $timestamp.datetime(f:'Week %V | %A | %Y-%m-%d %H:%M:%S') ";
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
        dunst.enable = true;
        network-manager-applet.enable = true;
        picom = {
          enable = true;
          activeOpacity = 1.0;
          inactiveOpacity = 1.0;
          opacityRules = [
            "100:class_g = 'ghostty'"
          ];
        };
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
                names = ["CodeNewRoman Nerd Font Mono"];
                size = 11.0;
              };
              mode = "hide";
              hiddenState = "hide";
              statusCommand = "${pkgs.i3status-rust}/bin/i3status-rs ~/.config/i3status-rust/config-default.toml";
              position = "bottom";
              trayOutput = "primary";
              workspaceButtons = true;
            }
          ];
          modes = {
            resize = {
              k = "resize grow height 10 px or 10 ppt";
              j = "resize shrink height 10 px or 10 ppt";
              h = "resize shrink width 10 px or 10 ppt";
              l = "resize grow width 10 px or 10 ppt";
              Up = "resize grow height 10 px or 10 ppt";
              Down = "resize shrink height 10 px or 10 ppt";
              Left = "resize shrink width 10 px or 10 ppt";
              Right = "resize grow width 10 px or 10 ppt";
              Escape = "mode default";
              Return = "mode default";
            };
          };
          keybindings = lib.mkOptionDefault {
            "${my-modifier}+Shift+h" = "move left";
            "${my-modifier}+Shift+j" = "move down";
            "${my-modifier}+Shift+k" = "move up";
            "${my-modifier}+Shift+l" = "move right";
            "${my-modifier}+h" = "focus left";
            "${my-modifier}+j" = "focus down";
            "${my-modifier}+k" = "focus up";
            "${my-modifier}+l" = "focus right";
            "${my-modifier}+Shift+apostrophe" = "splitv";
            "${my-modifier}+Shift+5" = "splith";
            "${my-modifier}+Shift+x" = "exec ${i3lock-dpms}";
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
