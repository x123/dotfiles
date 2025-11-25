{pkgs, ...}: {
  imports = [];

  home = {
    packages = with pkgs; [
      realesrgan-ncnn-vulkan
    ];
  };
}
