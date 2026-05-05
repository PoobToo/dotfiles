{ ... }:

{
  programs.eza = {
    enable = true;
    icons = "auto";
    git = true;
  };

  programs.bat.enable = true;
  programs.fzf.enable = true;

  programs.zoxide = {
    enable = true;
    enableFishIntegration = true;
    enableBashIntegration = true;
    options = [ "--cmd cd" ];
  };
}
