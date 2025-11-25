{...}: {
  imports = [
    ./docker.nix
    ./fail2ban.nix
    ./invidious.nix
    ./jellyfin.nix
    ./nftables.nix
    ./nix-ssh-serve.nix
    ./ollama.nix
    ./open-webui.nix
    ./openssh.nix
    ./qdrant.nix
    ./rustdesk-server.nix
    ./sonarr.nix
  ];
}
