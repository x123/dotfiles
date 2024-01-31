{pkgs, ...}: {
  imports = [];

  # discord
  nixpkgs.overlays = [
    (
      self: super: {
        discord = super.discord.overrideAttrs (
          _: {
            src = builtins.fetchTarball {
              url = "https://discord.com/api/download?platform=linux&format=tar.gz";
              # TODO try new version b678d933eb1c4d9e7e939df0fbc34d1d3879e1ffb634e00642102fc9df9a55b5
              sha256 = "1xjk77g9lj5b78c1w3fj42by9b483pkbfb41yzxrg4p36mnd2hkn";
            };
          }
        );
      }
    )
  ];

  home = {
    packages = [
      pkgs.discord
    ];
  };
}
