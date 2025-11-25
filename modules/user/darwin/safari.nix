{
  lib,
  pkgs,
  ...
}: {
  imports = [];

  config = lib.mkIf pkgs.stdenv.isDarwin {
    targets.darwin.defaults = {
      "com.apple.Safari" = {
        AutoFillCreditCardData = false;
        AutoFillPasswords = false;
        AutoOpenSafeDownloads = false;
        IncludeDevelopMenu = true;
        ShowOverlayStatusBar = true;
      };
      "com.apple.desktopservices".DSDontWriteNetworkStores = true;
      "com.apple.desktopservices".DSDontWriteUSBStores = true;
    };
  };
}
