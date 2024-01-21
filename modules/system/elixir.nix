{ pkgs, ... }: {
  imports = [ ];

  environment.systemPackages = with pkgs; [
    beam.packages.erlangR25.elixir_1_16
    erlang
  ];

}

