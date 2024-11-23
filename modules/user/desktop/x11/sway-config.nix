{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [];

  options = {
    custom.desktop.x11.sway = {
      enable = lib.mkOption {
        default = false;
        type = lib.types.bool;
        description = "Whether to enable sway.";
      };
    };
  };

  config =
    lib.mkIf (
      config.custom.desktop.enable
      && config.custom.desktop.x11.sway.enable
      && !pkgs.stdenv.isDarwin
    ) {
      home.packages = builtins.attrValues {
        inherit
          (pkgs)
          blueman
          dunst
          feh
          networkmanagerapplet
          redshift
          ;
        inherit (pkgs.xfce) thunar;
      };

      services = {
        wlsunset = {
          enable = true;
          gamma = 1.0;
          latitude = 55.7;
          longitude = 12.6;
          temperature = {
            day = 5700;
            night = 3600;
          };
        };
      };

      programs = {
        swaylock = {
          enable = true;
        };
      };

      wayland.windowManager.sway = {
        enable = true;
        config = {
          modifier = "Mod4";
          # keybindings = let
          #   modifier = config.wayland.windowManager.sway.config.modifier;
          # in
          #   lib.mkOptionDefault {
          #     # "${modifier}+Return" = "exec alacritty";
          #     # "${modifier}+Shift+q" = "kill";
          #     # "${modifier}+d" = "wofi";
          #   };
        };
        extraOptions = [
          "--unsupported-gpu"
        ];
      };

      programs = {
        wofi = {
          enable = true;
        };

        waybar = {
          enable = true;
          settings = {
            mainBar = {
              layer = "top";
              position = "bottom";
              height = 30;
              modules-left = [
                "sway/workspaces"
                "wlr/taskbar"
              ];
              modules-center = ["sway/mode"];
              modules-right = [
                "pulseaudio"
                "idle_inhibitor"
                "tray"
              ];

              "pulseaudio" = {
                format = "{volume}% {icon}";
                format-bluetooth = "{volume}% {icon}";
                format-muted = "";
                format-icons = {
                  "alsa_output.usb-Focusrite_Scarlett_2i4_USB-00.HiFi__Line1__sink" = "";
                  headphone = "";
                  default = ["" ""];
                };
                scroll-step = 1;
                on-click = "pavucontrol";
                ignored-sinks = [];
              };

              "idle_inhibitor" = {
                format = "{icon}";
                format-icons = {
                  activated = "☕";
                  deactivated = "😴";
                };
              };

              "sway/workspaces" = {
                disable-scroll = true;
                all-outputs = true;
              };
            };
          };
        };
      };

      xsession.enable = true;
    };
}
