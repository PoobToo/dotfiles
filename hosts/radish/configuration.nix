{ config, pkgs, ... }:

{
  imports = [
    ../../common
    ./hardware-configuration.nix
  ];

  networking.hostName = "radish";

  # LUKS
  boot.initrd.luks.devices."luks-b1ec9b3e-09fd-480c-a929-5171b0241b06".device = "/dev/disk/by-uuid/b1ec9b3e-09fd-480c-a929-5171b0241b06";

  services.sunshine = {
    enable = true;
    openFirewall = true;
    capSysAdmin = true;
    autoStart = false;
  };

  systemd.services.lid-inhibit = {
    description = "Inhibit lid-switch suspend (manual toggle)";
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.systemd}/bin/systemd-inhibit "
                + "--what=handle-lid-switch --who=lid-inhibit "
                + "--why='manual override' --mode=block "
                + "sleep infinity";
    };
  };

  security.polkit.extraConfig = ''
    polkit.addRule(function(action, subject) {
      if (action.id == "org.freedesktop.systemd1.manage-units" &&
          action.lookup("unit") == "lid-inhibit.service" &&
          subject.user == "leo") {
        return polkit.Result.YES;
      }
    });
  '';

  system.stateVersion = "25.11";
}
