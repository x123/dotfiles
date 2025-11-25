{inputs, ...}: {
  imports = [];

  # packages
  home.packages = [
    inputs.blender-bin.packages.x86_64-linux.blender_4_0
  ];
}
