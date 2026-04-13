{ config, lib, pkgs, modulesPath, ... }:

{
  # TODO: replace with generated hardware-configuration.nix from onion
  # Run `nixos-generate-config --show-hardware-config` on that machine
  imports = [ ];

  boot.initrd.availableKernelModules = [ ];
  boot.kernelModules = [ ];

  fileSystems."/" = {
    device = "/dev/disk/by-label/nixos";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-label/boot";
    fsType = "vfat";
  };
}
