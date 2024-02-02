{lib, ...}: {
  imports = [
    ./ai
    ./common
    ./darwin
    ./desktop
    ./dev
    ./editors
    ./mail
    ./shell
    ./x11
  ];

  options.custom = {
    ai.enable = lib.mkEnableOption "enable AI module";
    desktop.enable = lib.mkEnableOption "enable desktop environment";
    mail.enable = lib.mkEnableOption "enable mail clients";
  };
}
