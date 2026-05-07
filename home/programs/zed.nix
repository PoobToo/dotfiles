{ pkgs, ... }:

{
  programs.zed-editor = {
    enable = true;
    extensions = [
      "nix"
    ];
    userSettings = {
      theme = {
        mode = "dark";
      };
      telemetry = {
        diagnostics = false;
        metrics = false;
      };
      vim_mode = true;
    };
  };
}
