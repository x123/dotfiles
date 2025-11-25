{pkgs, ...}: {
  imports = [];

  targets.darwin.defauls = {
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
}
