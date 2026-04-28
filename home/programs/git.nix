{ ... }:

{
  programs.git = {
    enable = true;
    settings.user = {
      name = "Leo";
      email = "leo@radish";
    };
  };
}
