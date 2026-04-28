{ pkgs, ... }:

{
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set -g fish_greeting
    '';
    shellAliases = {
      rebuild = "sudo nixos-rebuild switch --flake ~/nixos#radish && home-manager switch --flake ~/nixos#leo-radish";
      battery = "cat /sys/class/power_supply/BATT/capacity";
      cat = "bat";
      jj = "vim ~/logseq/journals/$(date +%Y_%m_%d).md";
    };
    plugins = [
      {
        name = "autopair";
        src = pkgs.fishPlugins.autopair.src;
      }
    ];
  };
}
