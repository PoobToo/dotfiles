{ ... }:

{
  programs.foot = {
    enable = true;
    settings = {
      main = {
        font = "JetBrainsMono Nerd Font:size=17";
        pad = "10x0";
      };
      cursor = {
        style = "beam";
        blink = "yes";
      };
      colors-dark = {
        alpha = "0.9";
      };
    };
  };
}
