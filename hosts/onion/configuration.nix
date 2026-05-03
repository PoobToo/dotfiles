{ config, pkgs, ... }:

{
  imports = [
    ../../common
    ./hardware-configuration.nix
  ];

  networking.hostName = "onion";

  # Swap LUKS device (root LUKS lives in hardware-configuration.nix)
  boot.initrd.luks.devices."luks-fb485ae4-a2c1-4bf8-b98d-dac30301f41a".device =
    "/dev/disk/by-uuid/fb485ae4-a2c1-4bf8-b98d-dac30301f41a";

  # Nvidia funtimes
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.graphics.enable = true;
  hardware.nvidia = {
    modesetting.enable = true;
    open = true;
    nvidiaSettings = true;
    nvidiaPersistenced = true; # may(?) fix nvidia losing pinned clocks
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  # Piece-of-shit fuckin nvidia wont fix their clock speed ramp up issue 
  # making desktop anims stutter after idle. Pinning memory clocks as per
  # https://forums.developer.nvidia.com/t/desktop-animations-lag-after-a-few-seconds-of-inactivity/324208
  systemd.services.nvidia-pin-clocks = {
    description = "Pin NVIDIA memory clock to avoid idle ramp-up stutter";
    wantedBy = [ "multi-user.target" ];
    after = [ "nvidia-persistenced.service" ];
    requires = [ "nvidia-persistenced.service" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = "${config.hardware.nvidia.package.bin}/bin/nvidia-smi --lock-memory-clocks=5001,11201";
      ExecStop = "${config.hardware.nvidia.package.bin}/bin/nvidia-smi --reset-memory-clocks";
      Restart = "on-failure";
      RestartSec = "5s";
    };
  };

  # Re-pin after resume just in case
  systemd.services.nvidia-pin-clocks-resume = {
    description = "Re-pin NVIDIA memory clock after resume";
    wantedBy = [ "post-resume.target" ];
    after = [ "post-resume.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${config.hardware.nvidia.package.bin}/bin/nvidia-smi --lock-memory-clocks=5001,11201";
    };
  };

  system.stateVersion = "25.11";
}
