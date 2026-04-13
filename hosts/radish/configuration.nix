{ config, pkgs, ... }:

{
  imports = [
    ../../common
    ./hardware-configuration.nix
  ];

  networking.hostName = "radish";

  # LUKS
  boot.initrd.luks.devices."luks-b1ec9b3e-09fd-480c-a929-5171b0241b06".device = "/dev/disk/by-uuid/b1ec9b3e-09fd-480c-a929-5171b0241b06";

  system.stateVersion = "25.11";
}
