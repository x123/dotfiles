{lib, ...}: {
  imports = [
    ./apparmor.nix
    ./auditd.nix
    ./firejail.nix
  ];
}
