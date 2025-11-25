{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [];

  options = {
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

  config = lib.mkIf (config.custom.desktop.enable && !pkgs.stdenv.isDarwin) {
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
    services = {
      # blueman-applet.enable = true;
      # network-manager-applet.enable = true;
      wlsunset = {
        enable = true;
        gamma = 1.0;
        latitude = 55.7;
        longitude = 12.6;
        temperature = {
          day = 5700;
          night = 3600;
        };
        # {command = "${pkgs.redshift}/bin/redshift -l 55.7:12.6 -t 5700:3600 -P -g 1.0 -m randr -v";}
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
              timeout = 60;
              # timeout = 900;
              on-timeout = "hyprlock";
            }
            {
              timeout = 90;
              # timeout = 1200;
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
            # disable_loading_bar = true;
            # grace = 300;
            hide_cursor = true;
            no_fade_in = true;
          };

          background = [
            {
              path = "screenshot";
              blur_passes = 10;
              blur_size = 16;
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

    home.file = {
      hyprland-conf = {
        enable = true;
        target = ".config/hypr/hyprland.conf";
        text = ''
          ################
          ### MONITORS ###
          ################

          # See https://wiki.hyprland.org/Configuring/Monitors/
          monitor = DP-1, highrr, 0x0, 1

          ###################
          ### MY PROGRAMS ###
          ###################

          # See https://wiki.hyprland.org/Configuring/Keywords/

          # Set programs that you use
          $terminal = ghostty
          $fileManager = thunar
          $menu = wofi --show drun


          #################
          ### AUTOSTART ###
          #################

          # Autostart necessary processes (like notifications daemons, status bars, etc.)
          # Or execute your favorite apps at launch like this:

          # exec-once = $terminal
          # exec-once = nm-applet &
          # exec-once = waybar & hyprpaper & firefox


          #############################
          ### ENVIRONMENT VARIABLES ###
          #############################

          # See https://wiki.hyprland.org/Configuring/Environment-variables/

          env = XCURSOR_SIZE,24
          env = HYPRCURSOR_SIZE,24

          #####################
          ### LOOK AND FEEL ###
          #####################

          # Refer to https://wiki.hyprland.org/Configuring/Variables/

          # https://wiki.hyprland.org/Configuring/Variables/#general
          general {
              gaps_in = 5
              gaps_out = 20

              border_size = 2

              # https://wiki.hyprland.org/Configuring/Variables/#variable-types for info about colors
              col.active_border = rgba(33ccffee) rgba(00ff99ee) 45deg
              col.inactive_border = rgba(595959aa)

              # Set to true enable resizing windows by clicking and dragging on borders and gaps
              resize_on_border = false

              # Please see https://wiki.hyprland.org/Configuring/Tearing/ before you turn this on
              allow_tearing = false

              layout = dwindle
          }

          # https://wiki.hyprland.org/Configuring/Variables/#decoration
          decoration {
              rounding = 10

              # Change transparency of focused and unfocused windows
              active_opacity = 1.0
              inactive_opacity = 1.0

              shadow {
                  enabled = true
                  range = 4
                  render_power = 3
                  color = rgba(1a1a1aee)
              }

              # https://wiki.hyprland.org/Configuring/Variables/#blur
              blur {
                  enabled = true
                  size = 3
                  passes = 1

                  vibrancy = 0.1696
              }
          }

          # https://wiki.hyprland.org/Configuring/Variables/#animations
          animations {
              enabled = yes, please :)

              # Default animations, see https://wiki.hyprland.org/Configuring/Animations/ for more

              bezier = easeOutQuint,0.23,1,0.32,1
              bezier = easeInOutCubic,0.65,0.05,0.36,1
              bezier = linear,0,0,1,1
              bezier = almostLinear,0.5,0.5,0.75,1.0
              bezier = quick,0.15,0,0.1,1

              animation = global, 1, 10, default
              animation = border, 1, 5.39, easeOutQuint
              animation = windows, 1, 4.79, easeOutQuint
              animation = windowsIn, 1, 4.1, easeOutQuint, popin 87%
              animation = windowsOut, 1, 1.49, linear, popin 87%
              animation = fadeIn, 1, 1.73, almostLinear
              animation = fadeOut, 1, 1.46, almostLinear
              animation = fade, 1, 3.03, quick
              animation = layers, 1, 3.81, easeOutQuint
              animation = layersIn, 1, 4, easeOutQuint, fade
              animation = layersOut, 1, 1.5, linear, fade
              animation = fadeLayersIn, 1, 1.79, almostLinear
              animation = fadeLayersOut, 1, 1.39, almostLinear
              animation = workspaces, 1, 1.94, almostLinear, fade
              animation = workspacesIn, 1, 1.21, almostLinear, fade
              animation = workspacesOut, 1, 1.94, almostLinear, fade
          }

          # Ref https://wiki.hyprland.org/Configuring/Workspace-Rules/
          # "Smart gaps" / "No gaps when only"
          # uncomment all if you wish to use that.
          # workspace = w[t1], gapsout:0, gapsin:0
          # workspace = w[tg1], gapsout:0, gapsin:0
          # workspace = f[1], gapsout:0, gapsin:0
          # windowrulev2 = bordersize 0, floating:0, onworkspace:w[t1]
          # windowrulev2 = rounding 0, floating:0, onworkspace:w[t1]
          # windowrulev2 = bordersize 0, floating:0, onworkspace:w[tg1]
          # windowrulev2 = rounding 0, floating:0, onworkspace:w[tg1]
          # windowrulev2 = bordersize 0, floating:0, onworkspace:f[1]
          # windowrulev2 = rounding 0, floating:0, onworkspace:f[1]

          # See https://wiki.hyprland.org/Configuring/Dwindle-Layout/ for more
          dwindle {
              pseudotile = true # Master switch for pseudotiling. Enabling is bound to mainMod + P in the keybinds section below
              preserve_split = true # You probably want this
          }

          # See https://wiki.hyprland.org/Configuring/Master-Layout/ for more
          master {
              new_status = master
          }

          # https://wiki.hyprland.org/Configuring/Variables/#misc
          misc {
              force_default_wallpaper = -1 # Set to 0 or 1 to disable the anime mascot wallpapers
              disable_hyprland_logo = false # If true disables the random hyprland logo / anime girl background. :(
          }


          #############
          ### INPUT ###
          #############

          # https://wiki.hyprland.org/Configuring/Variables/#input
          input {
              kb_layout = us
              kb_variant =
              kb_model =
              kb_options = compose:ralt
              kb_rules =

              follow_mouse = 1

              sensitivity = 0 # -1.0 - 1.0, 0 means no modification.

              touchpad {
                  natural_scroll = false
              }
          }

          # https://wiki.hyprland.org/Configuring/Variables/#gestures
          gestures {
              workspace_swipe = false
          }

          # Example per-device config
          # See https://wiki.hyprland.org/Configuring/Keywords/#per-device-input-configs for more
          device {
              name = epic-mouse-v1
              sensitivity = -0.5
          }


          ###################
          ### KEYBINDINGS ###
          ###################

          # See https://wiki.hyprland.org/Configuring/Keywords/
          $mainMod = SUPER # Sets "Windows" key as main modifier

          # Example binds, see https://wiki.hyprland.org/Configuring/Binds/ for more
          bind = $mainMod, Return, exec, $terminal
          bind = $mainMod_SHIFT, Q, killactive,
          bind = $mainMod_SHIFT, R, exec, hyprctl reload
          bind = $mainMod, M, exit,
          bind = $mainMod, F, fullscreen
          bind = $mainMod, V, togglefloating,
          bind = $mainMod, D, exec, $menu
          bind = $mainMod, P, pseudo, # dwindle
          bind = $mainMod, J, togglesplit, # dwindle

          # Move focus with mainMod + arrow keys
          bind = $mainMod, left, movefocus, l
          bind = $mainMod, right, movefocus, r
          bind = $mainMod, up, movefocus, u
          bind = $mainMod, down, movefocus, d

          # Switch workspaces with mainMod + [0-9]
          bind = $mainMod, 1, workspace, 1
          bind = $mainMod, 2, workspace, 2
          bind = $mainMod, 3, workspace, 3
          bind = $mainMod, 4, workspace, 4
          bind = $mainMod, 5, workspace, 5
          bind = $mainMod, 6, workspace, 6
          bind = $mainMod, 7, workspace, 7
          bind = $mainMod, 8, workspace, 8
          bind = $mainMod, 9, workspace, 9
          bind = $mainMod, 0, workspace, 10

          # Move active window to a workspace with mainMod + SHIFT + [0-9]
          bind = $mainMod SHIFT, 1, movetoworkspace, 1
          bind = $mainMod SHIFT, 2, movetoworkspace, 2
          bind = $mainMod SHIFT, 3, movetoworkspace, 3
          bind = $mainMod SHIFT, 4, movetoworkspace, 4
          bind = $mainMod SHIFT, 5, movetoworkspace, 5
          bind = $mainMod SHIFT, 6, movetoworkspace, 6
          bind = $mainMod SHIFT, 7, movetoworkspace, 7
          bind = $mainMod SHIFT, 8, movetoworkspace, 8
          bind = $mainMod SHIFT, 9, movetoworkspace, 9
          bind = $mainMod SHIFT, 0, movetoworkspace, 10

          # Example special workspace (scratchpad)
          bind = $mainMod, S, togglespecialworkspace, magic
          bind = $mainMod SHIFT, S, movetoworkspace, special:magic

          # Scroll through existing workspaces with mainMod + scroll
          bind = $mainMod, mouse_down, workspace, e+1
          bind = $mainMod, mouse_up, workspace, e-1

          # Move/resize windows with mainMod + LMB/RMB and dragging
          bindm = $mainMod, mouse:272, movewindow
          bindm = $mainMod, mouse:273, resizewindow

          # Laptop multimedia keys for volume and LCD brightness
          bindel = ,XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+
          bindel = ,XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-
          bindel = ,XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
          bindel = ,XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle
          bindel = ,XF86MonBrightnessUp, exec, brightnessctl s 10%+
          bindel = ,XF86MonBrightnessDown, exec, brightnessctl s 10%-

          # Requires playerctl
          bindl = , XF86AudioNext, exec, playerctl next
          bindl = , XF86AudioPause, exec, playerctl play-pause
          bindl = , XF86AudioPlay, exec, playerctl play-pause
          bindl = , XF86AudioPrev, exec, playerctl previous

          ##############################
          ### WINDOWS AND WORKSPACES ###
          ##############################

          # See https://wiki.hyprland.org/Configuring/Window-Rules/ for more
          # See https://wiki.hyprland.org/Configuring/Workspace-Rules/ for workspace rules

          # Example windowrule v1
          # windowrule = float, ^(kitty)$

          # Example windowrule v2
          # windowrulev2 = float,class:^(kitty)$,title:^(kitty)$
          windowrulev2 = workspace 4 silent,class:^(org\.keepassxc\.KeePassXC)$

          # Ignore maximize requests from apps. You'll probably like this.
          windowrulev2 = suppressevent maximize, class:.*

          # Fix some dragging issues with XWayland
          windowrulev2 = nofocus,class:^$,title:^$,xwayland:1,floating:1,fullscreen:0,pinned:0
        '';
      };
    };

    programs = {
      wofi = {
        enable = true;
        # theme = "${pkgs.wofi}/share/wofi/themes/Arc-Dark.rasi";
        # settings = {};
        # terminal = "ghostty";
        # extraConfig = {
        #   dpi = 0;
        #   modes = "window,drun,ssh,run,combi";
        #   combi-modes = "window,ssh,drun,run";
        # };
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
    # xsession.windowManager.i3 = let
    #   my-modifier = "Mod4"; #Mod1 is alt
    #   # background = "${pkgs.plasma-workspace-wallpapers}/share/wallpapers/Path/contents/images/2560x1600.jpg";
    #   # fetch background from web
    #   # background = pkgs.fetchurl {
    #   # url = "https://raw.githubusercontent.com/NixOS/nixos-artwork/03c6c20be96c38827037d2238357f2c777ec4aa5/wallpapers/nix-wallpaper-dracula.png";
    #   # sha256 = "SykeFJXCzkeaxw06np0QkJCK28e0k30PdY8ZDVcQnh4=";
    #   # };
    # in {
    #   enable = true;
    #   config = {
    #     startup =
    #       [
    #         {command = "${pkgs.autorandr}/bin/autorandr -l home";}
    #         {command = "${pkgs.xorg.setxkbmap}/bin/setxkbmap -option compose:ralt";}
    #         #{command = "${pkgs.feh}/bin/feh --bg-fill ${background}";}
    #         {command = "${pkgs.dunst}/bin/dunst &";}
    #         {command = "${pkgs.picom}/bin/picom --daemon";}
    #         {command = "${pkgs.i3}/bin/i3-msg workspace 1";}
    #         {command = "${pkgs.redshift}/bin/redshift -l 55.7:12.6 -t 5700:3600 -P -g 1.0 -m randr -v";}
    #         {command = "${pkgs.networkmanagerapplet}/bin/nm-applet &";}
    #         {command = "${pkgs.blueman}/bin/blueman-applet &";}
    #       ]
    #       ++ (
    #         if pkgs.stdenv.isDarwin || pkgs.stdenv.hostPlatform.system == "aarch64-linux"
    #         then []
    #         else [
    #           {command = "${pkgs.dropbox}/bin/dropbox &";}
    #         ]
    #       );
    #     modifier = my-modifier;
    #     terminal = "ghostty";
    #     #terminal = "${pkgs.alacritty}/bin/alacritty";
    #     window = {
    #       hideEdgeBorders = "smart";
    #       titlebar = false;
    #     };
    #     bars = [
    #       {
    #         fonts = {
    #           names = ["CodeNewRoman Nerd Font"];
    #           size = 12.0;
    #         };
    #         mode = "dock";
    #         hiddenState = "show";
    #         statusCommand = "${pkgs.i3status-rust}/bin/i3status-rs ~/.config/i3status-rust/config-default.toml";
    #         position = "bottom";
    #         trayOutput = "primary";
    #         workspaceButtons = true;
    #       }
    #     ];
    #     keybindings = lib.mkOptionDefault {
    #       "${my-modifier}+Shift+l" = "exec ${i3lock-dpms}";
    #       "${my-modifier}+Tab" = "exec ${pkgs.rofi}/bin/rofi -show window";
    #       "${my-modifier}+d" = "exec ${pkgs.rofi}/bin/rofi -show combi";
    #       "${my-modifier}+Shift+s" = "sticky toggle";
    #     };
    #     focus = {
    #       followMouse = false;
    #       mouseWarping = true;
    #     };
    #   };
    # };
  };
}
