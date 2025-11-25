{...}: {
  imports = [];

  services.jellyfin = {
    enable = true;
    openFirewall = true;
  };
}
