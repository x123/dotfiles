{ pkgs ? import <nixpkgs> {} }:

with pkgs;

let
  inherit (lib) optional optionals;

  elixir = beam.packages.erlangR25.elixir_1_15;
  nodejs = nodejs_latest; # or nodejs or nodejs-10_x;
  postgresql = postgresql_16; # or postgresql100;
in

mkShell {
  buildInputs = [ elixir nodejs git postgresql ]
    ++ optional stdenv.isLinux inotify-tools # For file_system on Linux.
    ++ optionals stdenv.isDarwin (with darwin.apple_sdk.frameworks; [
      # For file_system on macOS.
      CoreFoundation
      CoreServices
    ]);

    # Put the PostgreSQL databases in the project diretory.
    shellHook = ''
      export PGDATA="$PWD/db"
    '';
}
