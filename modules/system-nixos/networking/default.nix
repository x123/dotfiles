{lib, ...}: {
  imports = [
    ./mullvad.nix
    ./tornet.nix
    ./wireguard.nix
  ];
}
