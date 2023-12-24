{pkgs, ...}: {
  imports = [];

  # calibre
#  nixpkgs.overlays = [(
#    self: super: {
#      calibre = super.calibre.overrideAttrs (
#        _: {
#          version = "7.2.0";
#          src = builtins.fetchurl {
#            url = "https://download.calibre-ebook.com/7.2.0/calibre-7.2.0.tar.xz";
#            sha256 = "1OZPSXF5cQlmwbD2bHVWtYHLUgCo8LaR1WPpuSUWoR8=";
#        }; }
#      );
#    }
#    )
#  ];

  home = {
    packages = with pkgs; [
      calibre
      libmtp
      optipng
    ];
  };
}
