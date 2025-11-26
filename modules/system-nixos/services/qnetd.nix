{
  config,
  lib,
  pkgs,
  ...
}: {
  options = {
    custom.system-nixos.services.qnetd = {
      enable = lib.mkOption {
        default = false;
        type = lib.types.bool;
        description = "Whether to enable the system qnetd service (for external voting)";
      };
      package = lib.mkOption {
        default = null;
        type = lib.types.package;
        description = "The corosync-qdevice package to use";
      };
      dataDir = lib.mkOption {
        default = "/var/lib/corosync-qnetd";
        type = lib.types.path;
        description = "Path to the writable data directory for qnetd configuration";
      };
    };
  };

  config = lib.mkIf (config.custom.system-nixos.enable && config.custom.system-nixos.services.qnetd.enable) {
    users.groups.corosync-qnetd = {};
    users.users.corosync-qnetd = {
      isSystemUser = true;
      group = "corosync-qnetd";
      description = "Corosync QNetd daemon user";
    };

    systemd.services.corosync-qnetd = {
      wantedBy = ["multi-user.target"];
      after = ["network.target"];
      description = "Corosync QNetd daemon";
      path = [pkgs.nss.tools];
      serviceConfig = {
        ExecStart = "${config.custom.system-nixos.services.qnetd.package}/bin/corosync-qnetd -f";
        Restart = "on-failure";
        StateDirectory = "corosync-qnetd";
        RuntimeDirectory = "corosync-qnetd";
        BindPaths = "${config.custom.system-nixos.services.qnetd.dataDir}:/etc/corosync/qnetd";
        ReadWritePaths = ["/etc/corosync/qnetd"];
        DynamicUser = false;
        User = "corosync-qnetd";
        Group = "corosync-qnetd";
        ExecStartPre = "+${pkgs.writeShellScript "corosync-qnetd-init" ''
          # Fix permissions of existing files
          ${pkgs.coreutils}/bin/chown -R corosync-qnetd:corosync-qnetd /etc/corosync/qnetd

          if [ ! -f /etc/corosync/qnetd/nssdb/cert8.db ] && [ ! -f /etc/corosync/qnetd/nssdb/cert9.db ]; then
            ${config.custom.system-nixos.services.qnetd.package}/bin/corosync-qnetd-certutil -i
            # Fix permissions of newly created files
            ${pkgs.coreutils}/bin/chown -R corosync-qnetd:corosync-qnetd /etc/corosync/qnetd
          fi
        ''}";
      };
    };
  };
}
