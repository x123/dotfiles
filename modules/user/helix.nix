{ pkgs, ... }: {
  imports = [ ];

  home = {
    packages = with pkgs; [
      helix
    ];
  };

  programs.helix = {
    enable = true;
    defaultEditor = false;
    settings = {
      theme = "nord";
      editor = {
        line-number = "relative";
        lsp.display-messages = true;
      };
    };
  };

}
