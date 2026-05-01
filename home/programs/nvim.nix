{ pkgs, ... }:

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

    globals.mapleader = " ";

    # Markdown LSP — gives gd/gr on wikilinks, doc symbols, etc.
    plugins.lsp = {
      enable = true;
      servers.marksman.enable = true;
    };

    # Treesitter for proper markdown rendering
    plugins.treesitter = {
      enable = true;
      settings = {
        highlight.enable = true;
        indent.enable = true;
      };
    };

    plugins.blink-cmp = {
      enable = true;
      settings = {
        keymap.preset = "super-tab";
        sources = {
          default = [ "lsp" "path" "buffer" "notes" ];
          providers.notes = {
            name = "Notes";
            module = "notes.source";
            score_offset = 100;
          };
        };
        completion.trigger.show_on_trigger_character = true;
      };
    };

    plugins.fzf-lua = {
      enable = true;
      keymaps = {
        "<leader>ff" = "files";
        "<leader>fg" = "live_grep";
        "<leader>fb" = "buffers";
        "<leader>fr" = "oldfiles";
      };
    };

    extraFiles = {
      "lua/notes/init.lua".source = ./lua/notes/init.lua;
      "lua/notes/pickers.lua".source = ./lua/notes/pickers.lua;
      "lua/notes/source.lua".source = ./lua/notes/source.lua;
    };
    
    extraConfigLua = ''
      require("notes")
    '';
    
    keymaps = [
      { mode = "n"; key = "<leader>jj"; action = "<cmd>Journal<cr>"; }
      { mode = "n"; key = "<leader>nf"; action.__raw = "function() require('notes.pickers').blocks() end"; }
      { mode = "n"; key = "<leader>nl"; action.__raw = "function() require('notes.pickers').wikilinks() end"; }
      { mode = "n"; key = "<leader>nt"; action.__raw = "function() require('notes.pickers').tags() end"; }
      { mode = "n"; key = "<leader>nb"; action.__raw = "function() require('notes.pickers').backlinks() end"; }
    ];
  };
}
