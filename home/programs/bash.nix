{ ... }:

{
  programs.bash = {
    enable = true;
    shellAliases = {
      rebuild = "sudo nixos-rebuild switch --flake ~/nixos#$(hostname) && home-manager switch --flake ~/nixos#leo-$(hostname)";
      battery = "cat /sys/class/power_supply/BATT/capacity";
      jj = "nvim ~/notes/journals/$(date +%Y_%m_%d).md";
    };
  };
}
