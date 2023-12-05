{pkgs, inputs, ...}: {
  imports = [];

  # packages
  home.packages = with inputs.blender-bin.packages; [
    x86_64-linux.blender_4_0
  ];

}
