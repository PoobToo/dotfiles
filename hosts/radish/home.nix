{ lib, ... }:
{
  programs.foot.settings.main.font = lib.mkForce "JetBrainsMono Nerd Font:size=10";
}
