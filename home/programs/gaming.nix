{ pkgs, ... }:

{
  home.packages = with pkgs; [
    lutris
    wineWow64Packages.staging
    winetricks
    protontricks
    mangohud
  ];
}
