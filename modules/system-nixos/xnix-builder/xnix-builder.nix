{
  config,
  lib,
  ...
}: {
  imports = [];

  config = lib.mkIf (config.custom.system-nixos.enable && config.custom.system-nixos.xnix-builder.enable) {
    nix = {
      distributedBuilds = true;

      settings = {
        connect-timeout = 5;
        builders-use-substitutes = true;
        # max-jobs = 0; # to disable building locally
        extra-substituters = ["ssh://xnix.empire.internal"];
        fallback = true;
      };

      buildMachines = [
        {
          hostName = "xnix.empire.internal";
          systems = ["x86_64-linux"];
          protocol = "ssh";
          publicHostKey = "c3NoLWVkMjU1MTkgQUFBQUMzTnphQzFsWkRJMU5URTVBQUFBSU80Z3N5VkcwYWgvejR6RFVKdDAvYTBsL0phV042VklhN1FCbERjT2s0U3Agcm9vdEB4bml4Cg==";
          maxJobs = 8;
          speedFactor = 9;
          sshUser = "builder";
          sshKey = "/etc/ssh/ssh_host_ed25519_key";
          supportedFeatures = ["nixos-test" "big-parallel" "kvm" "benchmark"];
        }
      ];
    };
  };
}
