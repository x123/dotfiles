{ pkgs ? import <nixpkgs> {} }:

with pkgs;

let
  inherit (lib) optional optionals;
  elixir = beam.packages.erlangR25.elixir_1_15;
in

mkShell {
  buildInputs = [ elixir git fwup squashfsTools file ]
    ++ optional stdenv.isDarwin coreutils-prefixed # For Nerves on macOS.
    ++ optional stdenv.isLinux x11_ssh_askpass; # For Nerves on Linux.

  # This hook is needed on Linux to make Nerves use the correct ssh_askpass.
  shellHooks = optional stdenv.isLinux ''
    export SUDO_ASKPASS=${x11_ssh_askpass}/libexec/x11-ssh-askpass
  '';
}
