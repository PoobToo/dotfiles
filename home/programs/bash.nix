{ ... }:

{
  programs.bash = {
    enable = true;
    shellAliases = {
      rebuild = "sudo nixos-rebuild switch --flake ~/nixos#radish && home-manager switch --flake ~/nixos#leo-radish";
      battery = "cat /sys/class/power_supply/BATT/capacity";
      jj = "vim ~/logseq/journals/$(date +%Y_%m_%d).md";
    };
  };
}
