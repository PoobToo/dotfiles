{ ... }:

{
  # Desktop shell (temporary — will replace with custom quickshell)
  programs.dank-material-shell = {
    enable = true;
    enableSystemMonitoring = false;
    systemd.enable = true;
  };
}
