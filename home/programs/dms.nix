{ ... }:

{
  # Desktop shell (temporary — will replace with custom quickshell)
  programs.dank-material-shell = {
    enable = true;
    enableSystemMonitoring = true;
    systemd.enable = true;
  };
}
