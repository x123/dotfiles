{pkgs, ...}: {
  systemd.services."kexec-load" = {
    unitConfig.DefaultDependencies = false;
    before = ["prepare-kexec.service"];
    serviceConfig = {
      Type = "oneshot";
      ExecStart =
        pkgs.writeShellScript "kexec-load"
        ''
          set -euo pipefail
          # Generate temporary initrd.img with LUKS master keys for kexec reboot

          umask 0077

          CRYPTROOT_TMPDIR="$(${pkgs.coreutils}/bin/mktemp -d --tmpdir=/dev/shm initrd.XXXXXXXXXX)"

          # clear the folder when exiting
          cleanup() {
              ${pkgs.coreutils}/bin/shred -fu "''${CRYPTROOT_TMPDIR}/initrd.img" || true
              ${pkgs.coreutils}/bin/shred -fu "''${CRYPTROOT_TMPDIR}/boot/crypto_keyfile.bin" || true
              ${pkgs.coreutils}/bin/rm -rf "''${CRYPTROOT_TMPDIR}"
          }

          trap cleanup INT TERM EXIT

          p=$(${pkgs.coreutils}/bin/readlink -f /nix/var/nix/profiles/system)
          if ! [ -d "$p" ]; then
            echo "Could not find system profile for prepare-kexec"
            exit 1
          fi

          # prepare the boot folder
          ${pkgs.coreutils}/bin/mkdir "''${CRYPTROOT_TMPDIR}/boot"
          ${pkgs.coreutils}/bin/cp /PATH/TO/KEYFILE "''${CRYPTROOT_TMPDIR}/boot/crypto_keyfile.bin"

          # append the boot folder to the initrd
          ${pkgs.coreutils}/bin/cp "$p/initrd" "''${CRYPTROOT_TMPDIR}/initrd.img"
          cd "''${CRYPTROOT_TMPDIR}"
          ${pkgs.findutils}/bin/find boot | ${pkgs.cpio}/bin/cpio -H newc -o | ${pkgs.gzip}/bin/gzip >> "''${CRYPTROOT_TMPDIR}/initrd.img"

          # load the new initrd (exec is needed)
          exec ${pkgs.kexec-tools}/bin/kexec --load "$p/kernel" --initrd="''${CRYPTROOT_TMPDIR}/initrd.img" --append="$(cat "$p/kernel-params") init=$p/init"
        '';
      # if anything in ExecStart fails, we make sure to cleanup /dev/shm
      ExecStopPost =
        pkgs.writeShellScript "kexec-load-cleanup"
        ''
          set -euo pipefail

          PREFIX="/dev/shm/initrd."

          for dir in ''${PREFIX}*/; do
              ${pkgs.coreutils}/bin/shred -fu "''${dir}/initrd.img" || true
              ${pkgs.coreutils}/bin/shred -fu "''${dir}/boot/crypto_keyfile.bin" || true
              ${pkgs.coreutils}/bin/rm -rf "''${dir}"
          done
        '';
    };
    wantedBy = ["kexec.target"];
  };
}
