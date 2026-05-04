{ lib, ... }:
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
}
