{pkgs, ...}: {
  imports = [];

  services.xserver = {
    enable = true;
    layout = "us";
    xkbVariant = "";

    autoRepeatDelay = 250;
    autoRepeatInterval = 45;

    desktopManager = {
      xterm.enable = false;
    };

    displayManager = {
      defaultSession = "none+i3";
      autoLogin.enable = false;
      lightdm = {
        enable = true;
        greeter.enable = true;
      };
    };

    windowManager = {
      i3.enable = true;
      i3.package = pkgs.i3; # or pkgs.i3-gaps
      i3.extraPackages = with pkgs; [
        dmenu #application launcher most people use
        i3status # gives you the default i3 status bar
        i3lock #default i3 screen locker
        #i3blocks #if you are planning on using i3blocks over i3status
        #i3-gaps
        #i3status-rust
        i3lock-fancy
        rofi
       ];
    };

  };

}
