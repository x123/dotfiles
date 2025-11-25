{pkgs, ...}: {
  imports = [];

  home = {
    packages =
      builtins.attrValues {
        inherit
          (pkgs)
          claude-code
          ;
      }
      ++ [pkgs.unstable-small.aider-chat-full];
  };
}
