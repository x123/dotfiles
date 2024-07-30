{...}: {
  imports = [
    ./invidious.nix
    ./jellyfin.nix
    ./nix-ssh-serve.nix
    ./rustdesk-server.nix
  ];
}
