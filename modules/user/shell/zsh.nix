{
  config,
  lib,
  ...
}: {
  imports = [];

  options = {
    custom.user.shell.zsh = {
      enable = lib.mkOption {
        default = true;
        type = lib.types.bool;
        description = "Whether to enable ZSH shell configuration";
      };
    };
  };

  config = lib.mkIf config.custom.user.shell.zsh.enable {
    programs.zsh = {
      enable = true;
      enableCompletion = true;

      oh-my-zsh = {
        enable = false;
        plugins = [
          "git"
          "sudo"
          "rsync"
        ];
      };

      envExtra = ''
        export PATH="$PATH:$HOME/bin:$HOME/.local/bin:$HOME/go/bin"
      '';
    };
  };
}
