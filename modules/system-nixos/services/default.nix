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
    ./p2pool.nix
    ./qdrant.nix
    ./rustdesk-server.nix
    ./sonarr.nix
    ./tang.nix
    ./tftp.nix
    ./xmrig.nix
    ./xmrig-proxy.nix
  ];
}
