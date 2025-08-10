{
  config,
  lib,
  pkgs,
  ...
}: {
  options = {
    custom.user.dev.llm.enable = lib.mkEnableOption "LLM and AI tools" // {default = true;};
  };

  config = lib.mkIf (config.custom.user.dev.enable && config.custom.user.dev.llm.enable) {
    home.packages = builtins.attrValues {
      inherit
        (pkgs.unstable-small)
        aider-chat-full
        claude-code
        fabric-ai
        opencode
        whisper-cpp
        ;
    };
  };
}
