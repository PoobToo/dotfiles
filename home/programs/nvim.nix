{ ... }:

{
  programs.nixvim = {
    enable = true;

    opts = {
      number = true;
      relativenumber = true;
      expandtab = true;
      tabstop = 2;
      shiftwidth = 2;
    };

    # Autocomplete
    plugins.blink-cmp.enable = true;

    # Fuzzy finder
    plugins.fzf-lua = {
      enable = true;
      keymaps = {
        "<leader>ff" = "files";
        "<leader>fg" = "live_grep";
        "<leader>fb" = "buffers";
        "<leader>fr" = "oldfiles";
      };
    };
  };
}
