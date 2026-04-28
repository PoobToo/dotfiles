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
  ];

  nixpkgs.config.allowUnfree = true;

  home.username = "leo";
  home.homeDirectory = "/home/leo";

  programs.home-manager.enable = true;

  home.stateVersion = "25.11";
}
