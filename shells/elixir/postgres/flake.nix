{
  description = "standard elixir devShell";

  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem
      (system:
      let
        pkgs = import nixpkgs { inherit system; };
        elixir = pkgs.beam.packages.erlangR25.elixir_1_15;
        postgresql = pkgs.postgresql_16; # or postgresql100;
      in
        {
          devShells.default = pkgs.mkShell {
            buildInputs = with pkgs; [
              elixir
              git
              erlang
              postgresql
            ]
            ++ pkgs.lib.optionals (pkgs.stdenv.isLinux) (with pkgs; [ gigalixir inotify-tools libnotify ])
            ++ pkgs.lib.optionals (pkgs.stdenv.isDarwin) (with pkgs; [ terminal-notifier ]
              ++ (with pkgs.darwin.apple_sdk.frameworks; [ CoreFoundation CoreServices ])
            );
            shellHook = ''
              export PGDATA="$PWD/db"
            '';

          };
        }
      );
}

