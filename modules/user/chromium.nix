{pkgs, lib, ...}:
let
  broken_on_darwin = with pkgs; [
  ];

in

with lib;
{
  home = {
    packages = with pkgs; [
      ungoogled-chromium
    ] ++ (if pkgs.stdenv.isDarwin then []
    else broken_on_darwin
    );
  };
}
