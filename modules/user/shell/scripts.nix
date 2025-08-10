{pkgs, ...}: {
  home.packages = [
    (pkgs.writeShellScriptBin "dni" ''
      #!/usr/bin/env bash
      set -euo pipefail

      # --- Defaults ---
      LOOKBACK_DAYS=30
      IP_ADDRESS=""
      JSON_OUTPUT=false

      # --- Usage Function ---
      usage() {
        echo "Usage: $0 <ip_address> [--lookback <days>] [-j] [-h|--help]" >&2
        echo "  <ip_address>      The IP address to query." >&2
        echo "  --lookback <days> Optional number of days to look back (default: 30)." >&2
        echo "  -j                Output full JSON instead of the default slim view." >&2
        echo "  -h, --help        Display this help message." >&2
        exit 1
      }

      # --- Argument Parsing ---
      while [[ $# -gt 0 ]]; do
        key="$1"
        case $key in
          --lookback)
            if [[ -z "''${2:-}" ]] || ! [[ "$2" =~ ^[0-9]+$ ]]; then
              echo "Error: --lookback requires a number of days." >&2
              exit 1
            fi
            LOOKBACK_DAYS="$2"
            shift 2
            ;;
          -j)
            JSON_OUTPUT=true
            shift
            ;;
          -h|--help)
            usage
            ;;
          *)
            if [ -z "$IP_ADDRESS" ]; then
              IP_ADDRESS="$1"
            fi
            shift
            ;;
        esac
      done

      # --- Input Validation ---
      if [ -z "$IP_ADDRESS" ]; then
        usage
      fi

      # --- Date Calculation ---
      START_DATE=$(${pkgs.coreutils}/bin/date -d "$LOOKBACK_DAYS days ago" +%Y-%m-%d)

      # --- Command Execution ---
      if [ "$JSON_OUTPUT" = true ]; then
        echo "Executing (json output): dnsdbq -j -T datefix -A ''${START_DATE} -s -i ''${IP_ADDRESS}" >&2
        ${pkgs.dnsdbq}/bin/dnsdbq -j -T datefix -A "''${START_DATE}" -s -i "''${IP_ADDRESS}"
      else
        echo "Executing: dnsdbq ... | jq | sed | sort | uniq" >&2
        ${pkgs.dnsdbq}/bin/dnsdbq -j -T datefix -A "''${START_DATE}" -s -i "''${IP_ADDRESS}" | ${pkgs.jq}/bin/jq '.rrname' | ${pkgs.gnused}/bin/sed 's/"//g' | ${pkgs.gnused}/bin/sed 's/\.$//g' | ${pkgs.coreutils}/bin/sort | ${pkgs.coreutils}/bin/uniq
      fi
    '')
  ];
}
