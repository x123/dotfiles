{...}: {
  imports = [
    ./docker.nix
    ./invidious.nix
    ./jellyfin.nix
    ./nftables.nix
    ./nix-ssh-serve.nix
    ./open-webui.nix
    ./openssh.nix
    ./qdrant.nix
  ];
}
