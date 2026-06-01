{ config, lib, pkgs, ... }:
let
  windowsRdp = pkgs.writeShellScriptBin "windows-rdp" ''
    set -eu
    pw=$(${pkgs.age}/bin/age -d -i "$HOME/.config/age/key.txt" ${../../secrets/windows-rdp.age})
    exec ${pkgs.freerdp}/bin/sdl-freerdp \
      /v:192.168.122.10 \
      /u:joe \
      /p:"$pw" \
      /cert:tofu \
      /dynamic-resolution \
      /clipboard \
      /sound \
      /drive:host,/home/leo \
      "$@"
  '';
in
{
  programs.niri.settings.outputs = {
    "LG Electronics LG ULTRAGEAR 109NTBKNT837" = {
      mode = { width = 2560; height = 1440; refresh = 164.958; };
      position = { x = 0; y = 0; };
      scale = 1.0;
      transform.rotation = 0;
    };
    "Acer Technologies XV271U M3 14040116D3LIJ" = {
      mode = { width = 2560; height = 1440; refresh = 180.002; };
      position = { x = 2560; y = -700; };
      scale = 1.0;
      transform.rotation = 270;
    };
  };

  home.packages = [
    pkgs.freerdp
    windowsRdp
  ];

  xdg.desktopEntries.windows-rdp = {
    name = "Windows (RDP)";
    comment = "Connect to the Windows VM via RDP";
    icon = "computer";
    exec = "windows-rdp";
    terminal = false;
    categories = [ "Network" "RemoteAccess" ];
  };
}
