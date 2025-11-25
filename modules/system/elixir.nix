{pkgs, ...}: {
  imports = [];

  environment.systemPackages = [
    pkgs.beam.packages.erlangR25.elixir_1_16
    pkgs.erlang
  ];
}
