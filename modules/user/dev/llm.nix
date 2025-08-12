{
  config,
  lib,
  pkgs,
  ...
}: {
  options = {
    custom.user.dev.llm.enable = lib.mkEnableOption "LLM and AI tools" // {default = true;};
  };

  # TODO add aider-chat-full back in once it's not broken
  config = lib.mkIf (config.custom.user.dev.enable && config.custom.user.dev.llm.enable) {
    home.packages = builtins.attrValues {
      inherit
        (pkgs.master)
        claude-code
        ;
      inherit
        (pkgs.unstable-small)
        fabric-ai
        opencode
        whisper-cpp
        ;
    };
  };
}
