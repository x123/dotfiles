{
  config,
  lib,
  ...
}: {
  imports = [
    ./direnv.nix
    ./docker.nix
    ./git.nix
    ./kube.nix
    ./llm.nix
    ./sqlite.nix
    ./websocat.nix
  ];

  options = {
    custom.user.dev = {
      enable = lib.mkOption {
        default = true;
        type = lib.types.bool;
        description = "Whether to enable dev environment";
      };
    };
  };

  config = lib.mkIf config.custom.user.dev.enable {
    # Parent configuration for dev environment
  };
}
