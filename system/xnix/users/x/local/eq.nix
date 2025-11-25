{
  lib,
  pkgs,
  ...
}: let
  # 1. Define all your keypress profiles here.
  # You can now add an optional "preKillKey" to any profile.
  # [	bracketleft
  # ]	bracketright
  # -	minus
  # =	equal
  # ;	semicolon
  # '	apostrophe
  # ,	comma
  # .	period
  # /	slash
  # \	backslash
  keypressConfigurations = {
    forage-o = {
      keyToPress = "o";
      windowName = "everquest";
      minInterval = 9807;
      maxInterval = 10491;
      minPress = 7;
      maxPress = 34;
      # No preKillKey for this one
    };

    shank = {
      keyToPress = "Control+l";
      windowName = "everquest";
      minInterval = 62500;
      maxInterval = 61100; # Note: Your max is less than your min here.
      minPress = 8;
      maxPress = 40;
      # No preKillKey for this one either
    };

    attack-q = {
      keyToPress = "q";
      windowName = "everquest";
      minInterval = 892;
      maxInterval = 1137;
      minPress = 9;
      maxPress = 32;
      # --- NEW: Define a key to press right before this loop stops ---
      preKillKey = "Control+q";
    };
  };

  # 2. The generic toggle script, now with pre-kill logic.
  toggle-keypress-script = pkgs.writeShellScript "toggle-keypress" ''
    set -euo pipefail
    # Read all arguments, including the new optional pre-kill key
    ACTION_ID="$1"; KEY_TO_PRESS="$2"; WINDOW_NAME="$3"; MIN_INTERVAL_MS="$4"; MAX_INTERVAL_MS="$5"; MIN_PRESS_MS="$6"; MAX_PRESS_MS="$7"
    PRE_KILL_KEY="$8"

    PID_FILE="/tmp/keypresser-''${ACTION_ID}.pid"

    if [ -f "$PID_FILE" ]; then
        echo "Stopping ''${ACTION_ID} loop...";

        # --- PRE-KILL ACTION LOGIC ---
        # First, check if a pre-kill key was actually provided.
        if [[ -n "$PRE_KILL_KEY" ]]; then
            echo "Executing pre-kill key: ''${PRE_KILL_KEY}"
            WINDOW_ID=$(${pkgs.xdotool}/bin/xdotool search --name "$WINDOW_NAME" | head -1)
            # Make sure the window still exists before sending the key
            if [[ -n "$WINDOW_ID" ]]; then
                # Send a simple, instant key press-and-release
                ${pkgs.xdotool}/bin/xdotool key --window "$WINDOW_ID" "$PRE_KILL_KEY"
            fi
        fi
        # ---------------------------

        # Now, kill the original loop and clean up
        kill $(cat $PID_FILE);
        rm $PID_FILE;
    else
        echo "Starting ''${ACTION_ID} loop...";
        (while true; do
            WINDOW_ID=$(${pkgs.xdotool}/bin/xdotool search --name "$WINDOW_NAME" | head -1)
            if [ -z "$WINDOW_ID" ]; then sleep 1; continue; fi
            PRESS_RANGE=$((MAX_PRESS_MS - MIN_PRESS_MS + 1)); RANDOM_PRESS_MS=$(($MIN_PRESS_MS + RANDOM % PRESS_RANGE))
            PRESS_DURATION_S=$(${pkgs.bc}/bin/bc <<< "scale=4; $RANDOM_PRESS_MS / 1000")
            ${pkgs.xdotool}/bin/xdotool keydown --window "$WINDOW_ID" "$KEY_TO_PRESS"; sleep "$PRESS_DURATION_S"; ${pkgs.xdotool}/bin/xdotool keyup --window "$WINDOW_ID" "$KEY_TO_PRESS"
            INTERVAL_RANGE=$((MAX_INTERVAL_MS - MIN_INTERVAL_MS + 1)); RANDOM_INTERVAL_MS=$(($MIN_INTERVAL_MS + RANDOM % INTERVAL_RANGE))
            SLEEP_S=$(${pkgs.bc}/bin/bc <<< "scale=3; $RANDOM_INTERVAL_MS / 1000")
            echo "''${ACTION_ID}: Pressed ''${KEY_TO_PRESS} for ''${PRESS_DURATION_S}s, waiting for ''${SLEEP_S}s"; sleep "$SLEEP_S";
        done & echo $! > "$PID_FILE")
    fi
  '';

  # 3. Bindings definition (unchanged)
  bindings = {
    "b:9" = ["attack-q" "shank"];
    "Control+Shift+f" = ["forage-o"];
  };
in {
  home.packages = [pkgs.xbindkeys];
  home.file = {
    xbindkeysrc = {
      enable = true;
      target = ".xbindkeysrc";
      # 4. Master script generation, now passing the 8th argument.
      text = lib.concatStringsSep "\n\n" (
        lib.mapAttrsToList (trigger: actionIds: let
          masterScript = pkgs.writeShellScript "master-toggle-${trigger}" ''
            set -e
            echo "Triggering group for ${trigger}"
            ${lib.concatStringsSep "\n" (map (
                actionId: let
                  cfg = keypressConfigurations.${actionId};
                  # If cfg.preKillKey exists, use it. Otherwise, pass an empty string.
                  preKillKeyArg = cfg.preKillKey or "";
                in
                  # Pass the preKillKey as the 8th argument. Use quotes to handle empty strings.
                  "${toggle-keypress-script} ${actionId} ${cfg.keyToPress} ${cfg.windowName} ${toString cfg.minInterval} ${toString cfg.maxInterval} ${toString cfg.minPress} ${toString cfg.maxPress} '${preKillKeyArg}'"
              )
              actionIds)}
          '';
        in ''
          # Binding for trigger: ${trigger}
          "${masterScript}"
             ${trigger}
        '')
        bindings
      );
    };
  };
}
