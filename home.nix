{ config, pkgs, ... }:

{
  home.username = "leo";
  home.homeDirectory = "/home/leo";

  home.packages = with pkgs; [
    # user packages go here
  ];

  programs.git = {
    enable = true;
    userName = "Leo";
    userEmail = "leo@radish";
  };

  programs.bash = {
    enable = true;
    shellAliases = {
      rebuild = "sudo nixos-rebuild switch --flake ~/nixos#radish && home-manager switch --flake ~/nixos#leo";
      bat = "cat /sys/class/power_supply/BATT/capacity";
    };
  };

  # Let home-manager manage itself in standalone mode
  programs.home-manager.enable = true;

  home.stateVersion = "25.11";
}
