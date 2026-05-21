{ lib, ... }:
{
  programs.foot.settings.main.font = lib.mkForce "JetBrainsMono Nerd Font:size=10";

  programs.fish.shellAliases = {
    lid-inhibit = "systemctl start lid-inhibit";
    lid-release = "systemctl stop lid-inhibit";
    lid-status  = "systemctl is-active lid-inhibit";
  };
}
