{pkgs, ...}: {
  imports = [];

  home = {
    packages = with pkgs; [
      python310Packages.torchWithCuda
      python310Packages.torchvision-bin
    ];
  };
}
