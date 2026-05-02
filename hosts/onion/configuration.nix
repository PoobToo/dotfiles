{ config, lib, pkgs, ... }:

{
  imports = [
    ../../common
    ./hardware-configuration.nix
  ];

  networking.hostName = "onion";

  # Swap LUKS device (root LUKS lives in hardware-configuration.nix)
  boot.initrd.luks.devices."luks-fb485ae4-a2c1-4bf8-b98d-dac30301f41a".device =
    "/dev/disk/by-uuid/fb485ae4-a2c1-4bf8-b98d-dac30301f41a";

  # Using stock kernel for now TODO switch to cachyos kernel once initial setup is up
  boot.kernelPackages = lib.mkForce pkgs.linuxPackages_latest;

  # Nvidia funtimes
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.graphics.enable = true;
  hardware.nvidia = {
    modesetting.enable = true;
    open = true;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  system.stateVersion = "25.11";
}
