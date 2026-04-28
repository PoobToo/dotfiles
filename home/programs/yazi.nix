{ ... }:

{
  programs.yazi = {
    enable = true;
    settings = {
      opener = {
        edit = [{ run = ''nvim "$@"''; block = true; }];
        image = [{ run = ''imv "$@"''; }];
        video = [{ run = ''mpv "$@"''; }];
      };
      open.rules = [
        { mime = "image/*"; use = "image"; }
        { mime = "video/*"; use = "video"; }
        { name = "*"; use = "edit"; }
      ];
    };
  };
}
