{ ... }:
{
  programs.yazi = {
    enable = true;
    settings = {
      opener = {
        edit  = [{ run = ''nvim "$@"''; block = true; }];
        image = [{ run = ''imv "$@"''; }];
        video = [{ run = ''mpv "$@"''; }];
      };
      open = {
        prepend_rules = [
          { mime = "image/*"; use = "image"; }
          { mime = "video/*"; use = "video"; }
        ];
        append_rules = [
          { name = "*"; use = "edit"; }
        ];
      };
    };
  };
}
