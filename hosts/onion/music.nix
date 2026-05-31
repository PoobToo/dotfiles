{ pkgs, ... }:

let
  chow-tape-model = pkgs.callPackage ./chow-tape-model.nix { };
in
{
  security.rtkit.enable = true;

  # Point Reaper (and other hosts) at plugins installed via systemPackages.
  environment.sessionVariables = {
    VST3_PATH = "$HOME/.vst3:/run/current-system/sw/lib/vst3";
    CLAP_PATH = "$HOME/.clap:/run/current-system/sw/lib/clap";
    LXVST_PATH = "$HOME/.vst:/run/current-system/sw/lib/vst";
    VST_PATH = "$HOME/.vst:/run/current-system/sw/lib/vst";
    LV2_PATH = "$HOME/.lv2:/run/current-system/sw/lib/lv2";
  };

  services.pipewire.extraConfig.pipewire."92-low-latency" = {
    "context.properties" = {
      "default.clock.rate" = 48000;
      "default.clock.quantum" = 64;
      "default.clock.min-quantum" = 32;
      "default.clock.max-quantum" = 256;
    };
  };

  environment.systemPackages = with pkgs; [
    reaper
    yabridge
    yabridgectl
    qpwgraph

    # Plugins
    lsp-plugins
    x42-plugins
    dragonfly-reverb
    surge-xt
    vital
    airwin2rack
    airwindows-lv2
    cardinal
    chow-tape-model
  ];
}
