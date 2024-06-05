{pkgs, ...}: {
  imports = [];

  environment.systemPackages = [
    pkgs.beam.packages.erlang_25.elixir_1_16
    pkgs.erlang
  ];
}
