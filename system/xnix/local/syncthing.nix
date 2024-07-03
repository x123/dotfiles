{config, ...}: {
  services = {
    syncthing = {
      enable = true;
      guiAddress = "127.0.0.1:8384";
      user = "x";
      group = "users";
      dataDir = "/home/x/syncthing";

      # cert = config.security.acme.certs."boxchop.city".directory + "/full.pem";
      # key = config.security.acme.certs."boxchop.city".directory + "/key.pem";
      systemService = true;

      settings = {
        devices = {
          "hetznix" = {
            address = [
              "tcp://hetznix.boxchop.city:22000"
            ];
            id = "U426R4S-IGJMMDR-VL73OYB-EIH2UXH-2MPVYHG-CMQVSNQ-ETNFCAP-YI64NQR";
          };
          "xnix" = {id = "TGCIWO2-IIDQELC-BOXUJZO-G3E5SIA-XSQ4CC3-EDG6JOF-VWBNSUK-J7WTEAF";};
        };
        folders = {
          "syncthing" = {
            path = "/home/x/syncthing/syncthing";
            devices = ["hetznix" "xnix"];
          };
        };
      };

      # relay = {
      #   enable = true;
      #   listenAddress = "0.0.0.0";
      #   port = 22067; # TCP/22067
      #   statusListenAddress = "0.0.0.0";
      #   statusPort = 22070; # TCP/22070
      # };
    };
  };
}
