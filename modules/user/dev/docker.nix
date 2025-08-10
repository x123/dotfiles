{
  config,
  lib,
  pkgs,
  ...
}: {
  options = {
    custom.user.dev.docker.enable = lib.mkEnableOption "docker and container tools" // {default = true;};
  };

  config = lib.mkIf (config.custom.user.dev.enable && config.custom.user.dev.docker.enable) {
    home.packages = builtins.attrValues {
      inherit
        (pkgs)
        lima
        lima-additional-guestagents
        podman
        ;
    };
  };
}
