{ ... }:

{
  programs.starship = {
    enable = true;
    settings = {
      format = "$directory$git_branch$git_status$python$rust$nodejs$nix_shell$cmd_duration$line_break$character";
      directory = {
        style = "blue bold";
      };
      git_branch = {
        format = "[$branch]($style) ";
        style = "purple";
      };
      git_status = {
        format = "[$all_status$ahead_behind]($style) ";
      };
      python = {
        format = "[($virtualenv )$version]($style) ";
      };
      character = {
        success_symbol = "[❯](green)";
        error_symbol = "[❯](red)";
      };
      cmd_duration = {
        format = "[$duration]($style) ";
        min_time = 5000;
      };
    };
  };
}
