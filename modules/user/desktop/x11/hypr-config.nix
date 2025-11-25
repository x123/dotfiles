{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [];

  options = {
    custom.desktop.x11.hyprland = {
      enable = lib.mkOption {
        default = true;
        type = lib.types.bool;
        description = "Whether to enable hyprland.";
      };
    };
  };

  config =
    lib.mkIf (
      config.custom.desktop.enable
      && config.custom.desktop.x11.hyprland.enable
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

        hyprpaper = {
          enable = true;
          settings = {
            ipc = "on";
            splash = false;
            splash_offset = 2.0;

            preload = ["${config.home.homeDirectory}/priv/images/bg.png"];

            wallpaper = [
              "DP-1,${config.home.homeDirectory}/priv/images/bg.png"
            ];
          };
        };

        hypridle = {
          enable = true;
          settings = {
            general = {
              after_sleep_cmd = "hyprctl dispatch dpms on";
              ignore_dbus_inhibit = false;
              lock_cmd = "hyprlock";
            };

            listener = [
              {
                timeout = 900;
                on-timeout = "hyprlock";
              }
              {
                timeout = 1200;
                on-timeout = "hyprctl dispatch dpms off";
                on-resume = "hyprctl dispatch dpms on";
              }
            ];
          };
        };
      };

      programs = {
        hyprlock = {
          enable = true;
          settings = {
            general = {
              disable_loading_bar = false;
              hide_cursor = true;
              no_fade_in = true;
              no_fade_out = true;
            };

            background = [
              {
                path = "";
              }
            ];

            input-field = [
              {
                size = "200, 50";
                position = "0, -80";
                monitor = "";
                dots_center = true;
                fade_on_empty = false;
                font_color = "rgb(202, 211, 245)";
                inner_color = "rgb(91, 96, 120)";
                outer_color = "rgb(24, 25, 38)";
                outline_thickness = 5;
                placeholder_text = "Password";
                shadow_passes = 2;
              }
            ];
          };
        };
      };

      wayland.windowManager.hyprland = {
        enable = true;
        settings = {
          monitor = [
            ", highrr, auto, 1"
          ];
          exec-once = [
            "systemctl --user restart wlsunset.service"
            "systemctl --user restart xdg-desktop-portal-gtk.service"
            "systemctl --user restart hyperpaper.service"
            "systemctl --user restart hypridle.service"
            "waybar"
            "${pkgs.networkmanagerapplet}/bin/nm-applet &"
            "${pkgs.blueman}/bin/blueman-applet &"
            "firejail --name=browser firefox & ghostty"
            # "firejail --name=browser firefox --no-remote --new-instance & ghostty"
            "firejail --name=keepassxc keepassxc"
            "firejail --name=discord Discord"
          ];

          env = [
            "XCURSOR_SIZE,24"
            "HYPRCURSOR_SIZE,24"
          ];

          "$terminal" = "ghostty";
          "$fileManager" = "thunar";
          "$menu" = "wofi --show drun";

          general = {
            gaps_in = 5;
            gaps_out = 20;

            border_size = 2;

            # https://wiki.hyprland.org/Configuring/Variables/#variable-types for info about colors
            "col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
            "col.inactive_border" = "rgba(595959aa)";

            # Set to true enable resizing windows by clicking and dragging on borders and gaps
            resize_on_border = false;

            # Please see https://wiki.hyprland.org/Configuring/Tearing/ before you turn this on
            allow_tearing = false;

            layout = "dwindle";
          };

          # https://wiki.hyprland.org/Configuring/Variables/#decoration
          decoration = {
            rounding = 10;

            # Change transparency of focused and unfocused windows
            active_opacity = 1.0;
            inactive_opacity = 1.0;

            shadow = {
              enabled = true;
              range = 4;
              render_power = 3;
              color = "rgba(1a1a1aee)";
            };

            # https://wiki.hyprland.org/Configuring/Variables/#blur
            blur = {
              enabled = true;
              size = 3;
              passes = 1;
              vibrancy = 0.1696;
            };
          };

          # https://wiki.hyprland.org/Configuring/Variables/#animations
          animations = {
            enabled = true;

            # Default animations, see https://wiki.hyprland.org/Configuring/Animations/ for more
            bezier = [
              "easeOutQuint,0.23,1,0.32,1"
              "easeInOutCubic,0.65,0.05,0.36,1"
              "linear,0,0,1,1"
              "almostLinear,0.5,0.5,0.75,1.0"
              "quick,0.15,0,0.1,1"
            ];

            animation = [
              "global, 1, 10, default"
              "border, 1, 5.39, easeOutQuint"
              "windows, 1, 4.79, easeOutQuint"
              "windowsIn, 1, 4.1, easeOutQuint, popin 87%"
              "windowsOut, 1, 1.49, linear, popin 87%"
              "fadeIn, 1, 1.73, almostLinear"
              "fadeOut, 1, 1.46, almostLinear"
              "fade, 1, 3.03, quick"
              "layers, 1, 3.81, easeOutQuint"
              "layersIn, 1, 4, easeOutQuint, fade"
              "layersOut, 1, 1.5, linear, fade"
              "fadeLayersIn, 1, 1.79, almostLinear"
              "fadeLayersOut, 1, 1.39, almostLinear"
              "workspaces, 1, 1.94, almostLinear, fade"
              "workspacesIn, 1, 1.21, almostLinear, fade"
              "workspacesOut, 1, 1.94, almostLinear, fade"
            ];
          };

          input = {
            kb_layout = "us";
            kb_options = "compose:ralt";

            follow_mouse = 1;

            sensitivity = 0; # -1.0 - 1.0, 0 means no modification.

            touchpad = {
              natural_scroll = false;
            };
          };

          dwindle = {
            pseudotile = true; # Master switch for pseudotiling. Enabling is bound to mainMod + P in the keybinds section below
            preserve_split = true; # You probably want this
          };

          # See https://wiki.hyprland.org/Configuring/Master-Layout/ for more
          master = {
            new_status = "master";
          };

          # https://wiki.hyprland.org/Configuring/Variables/#misc
          misc = {
            force_default_wallpaper = 1; # Set to 0 or 1 to disable the anime mascot wallpapers
            disable_hyprland_logo = false; # If true disables the random hyprland logo / anime girl background. :(
          };
          # See https://wiki.hyprland.org/Configuring/Keywords/
          "$mainMod" = "SUPER"; # Sets "Windows" key as main modifier

          bind = [
            # Example binds, see https://wiki.hyprland.org/Configuring/Binds/ for more
            "$mainMod, Return, exec, $terminal"
            "$mainMod_SHIFT, Q, killactive,"
            "$mainMod_SHIFT, R, exec, hyprctl reload"
            "$mainMod_SHIFT, M, exit,"
            "$mainMod_SHIFT, L, exec, hyprlock"
            "$mainMod, F, fullscreen"
            "$mainMod, V, togglefloating,"
            "$mainMod, D, exec, $menu"
            "$mainMod, P, pseudo, # dwindle"
            "$mainMod, J, togglesplit, # dwindle"

            # Move focus with mainMod + arrow keys
            "$mainMod, left, movefocus, l"
            "$mainMod, right, movefocus, r"
            "$mainMod, up, movefocus, u"
            "$mainMod, down, movefocus, d"

            # Switch workspaces with mainMod + [0-9]"
            "$mainMod, 1, workspace, 1"
            "$mainMod, 2, workspace, 2"
            "$mainMod, 3, workspace, 3"
            "$mainMod, 4, workspace, 4"
            "$mainMod, 5, workspace, 5"
            "$mainMod, 6, workspace, 6"
            "$mainMod, 7, workspace, 7"
            "$mainMod, 8, workspace, 8"
            "$mainMod, 9, workspace, 9"
            "$mainMod, 0, workspace, 10"

            # Move active window to a workspace with mainMod + SHIFT + [0-9]
            "$mainMod SHIFT, 1, movetoworkspace, 1"
            "$mainMod SHIFT, 2, movetoworkspace, 2"
            "$mainMod SHIFT, 3, movetoworkspace, 3"
            "$mainMod SHIFT, 4, movetoworkspace, 4"
            "$mainMod SHIFT, 5, movetoworkspace, 5"
            "$mainMod SHIFT, 6, movetoworkspace, 6"
            "$mainMod SHIFT, 7, movetoworkspace, 7"
            "$mainMod SHIFT, 8, movetoworkspace, 8"
            "$mainMod SHIFT, 9, movetoworkspace, 9"
            "$mainMod SHIFT, 0, movetoworkspace, 10"

            # Example special workspace (scratchpad)
            "$mainMod, S, togglespecialworkspace, magic"
            "$mainMod SHIFT, S, movetoworkspace, special:magic"

            # Scroll through existing workspaces with mainMod + scroll
            "$mainMod, mouse_down, workspace, e+1"
            "$mainMod, mouse_up, workspace, e-1"
          ];
          # Move/resize windows with mainMod + LMB/RMB and dragging
          bindm = [
            "$mainMod, mouse:272, movewindow"
            "$mainMod, mouse:273, resizewindow"
          ];
          # Laptop multimedia keys for volume and LCD brightness
          bindel = [
            ",XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
            ",XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
            ",XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
            ",XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
            ",XF86MonBrightnessUp, exec, brightnessctl s 10%+"
            ",XF86MonBrightnessDown, exec, brightnessctl s 10%-"
          ];
          bindl = [
            # Requires playerctl
            ", XF86AudioNext, exec, playerctl next"
            ", XF86AudioPause, exec, playerctl play-pause"
            ", XF86AudioPlay, exec, playerctl play-pause"
            ", XF86AudioPrev, exec, playerctl previous"
          ];

          windowrulev2 = [
            ##############################
            ### WINDOWS AND WORKSPACES ###
            ##############################

            # See https://wiki.hyprland.org/Configuring/Window-Rules/ for more
            # See https://wiki.hyprland.org/Configuring/Workspace-Rules/ for workspace rules

            # Example windowrule v0
            # windowrule = float, ^(kitty)$

            # Example windowrule v1
            # windowrulev1 = float,class:^(kitty)$,title:^(kitty)$
            "workspace 4 silent,class:^(org\.keepassxc\.KeePassXC)$"

            # Ignore maximize requests from apps. You'll probably like this.
            "suppressevent maximize, class:.*"

            # Fix some dragging issues with XWayland
            "nofocus,class:^$,title:^$,xwayland:1,floating:1,fullscreen:0,pinned:0"
          ];
        };
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
              output = [
                "DP-1"
              ];
              modules-left = [
                "hyprland/workspaces"
                "wlr/taskbar"
              ];
              modules-center = ["hyprland/window"];
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

              "hyprland/workspaces" = {
                disable-scroll = true;
                all-outputs = true;
              };
            };
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
      };

      xsession.enable = true;
    };
}
