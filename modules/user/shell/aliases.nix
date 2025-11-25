{
  config,
  lib,
  ...
}: {
  options = {
    custom.user.shell.aliases = {
      enable = lib.mkOption {
        default = true;
        type = lib.types.bool;
        description = "Whether to enable shell aliases";
      };
    };
  };

  config = lib.mkIf (config.custom.user.shell.enable && config.custom.user.shell.aliases.enable) {
    home = {
      shellAliases = {
        hetznix = "ssh hetznix";
        ls = "ls --color";
        less = "less -mNg";
        nsp = "nix search nixpkgs";
        dns-cache-flush = "sudo dscacheutil -flushcache && sudo killall -HUP mDNSResponder";

        narsil-term = "narsil -mgcu -- -n4";
        angband-term = "angband -c -mgcu -- -B -K -n4";
        tintin = "tt++";
        reboot-to-bios = "sudo systemctl reboot --firmware-setup";
        power = "sudo turbostat --quiet --interval 1 --Summary --cpu package --show PkgWatt,Busy%,Core,CoreTmp,Thermal";
        fj-firefox-tornet = "firejail --name=browser-tornet --net=tornet --dns=5.9.164.112 --profile=$(nix eval --raw nixpkgs#firejail)/etc/firejail/firefox.profile firefox --private-window";
        fj-curl = "firejail --net=tornet --dns=5.9.164.112 --profile=$(nix eval --raw nixpkgs#firejail)/etc/firejail/curl.profile curl";
        # fabric aliases
        "toregex" = "fabric -r -p toregex";
        # subset of oh-my-zsh aliases
        "ga" = "git add";
        "gaa" = "git add --all";
        "gapa" = "git add --patch";
        "gb" = "git branch";
        "gbd" = "git branch -d";
        "gbD" = "git branch -D";
        "gc" = "git commit -v";
        "gc!" = "git commit -v --amend";
        "gcan" = "git commit -v --no-edit --amend";
        "gcb" = "git checkout -b";
        "gcm" = "git checkout master";
        "gcmsg" = "git commit -m";
        "gco" = "git checkout";
        "gd" = "git diff";
        "gds" = "git diff --staged";
        "gdss" = "git diff --staged --shortstat";
        "gl" = "git pull";
        "glol" = "git log --graph --pretty='%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ar) %C(bold blue)<%an>%Creset'";
        "gm" = "git merge";
        "gp" = "git push";
        "gpf" = "git push --force-with-lease";
        "gpf!" = "git push --force";
        "grs" = "git restore";
        "grst" = "git restore --staged";
        "gsh" = "git show";
        "gst" = "git status";
        # TODO: make this a script (to install terminfo on remotes)
        # "infocmp -x | ssh SOMEMACHINE -- tic -x -"
      };
    };
  };
}
