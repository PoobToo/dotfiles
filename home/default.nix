{ ... }:

{
  imports = [
    ./packages.nix
    ./programs/niri.nix
    ./programs/fish.nix
    ./programs/foot.nix
    ./programs/git.nix
    ./programs/starship.nix
    ./programs/bash.nix
    ./programs/shell-tools.nix
    ./programs/dms.nix
    ./programs/nvim.nix
    ./programs/yazi.nix
  ];

  nixpkgs.config.allowUnfree = true;

  home.username = "leo";
  home.homeDirectory = "/home/leo";

  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
    PAGER = "bat";
    MANPAGER = "bat -l man -p";
    BROWSER = "firefox";
  };

  programs.home-manager.enable = true;

  home.stateVersion = "25.11";
}
