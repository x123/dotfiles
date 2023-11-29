{pkgs, ...}: {
  imports = [];

  # discord
  nixpkgs.overlays = [(
    self: super: {
      discord = super.discord.overrideAttrs (
        _: { src = builtins.fetchTarball {
          url = "https://discord.com/api/download?platform=linux&format=tar.gz";
          sha256 = "1xjk77g9lj5b78c1w3fj42by9b483pkbfb41yzxrg4p36mnd2hkn";
        }; }
      );
    }
    )
  ];

  home = {
    packages = with pkgs; [
      discord
    ];
  };

}
