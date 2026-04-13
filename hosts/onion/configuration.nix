{ config, pkgs, ... }:

{
  imports = [
    ../../common
    ./hardware-configuration.nix
  ];

  networking.hostName = "onion";

  # TODO: copy hardware-configuration.nix from onion here
  # TODO: add LUKS device if applicable
  # TODO: add any desktop-specific packages (GPU drivers, etc.)

  system.stateVersion = "25.11";
}
